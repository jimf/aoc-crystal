require "./intcode.cr"
require "./point.cr"

module Advent2019_15
  extend self

  # Binary min-heap
  private class PriorityQueue
    def initialize
      # First element isn't used. Merely here to ease other operations.
      @heap = [{0, Point.new}]
    end

    def push(value, data)
      @heap.push({value, data})
      bubble_up @heap.size - 1
      self
    end

    def pop
      if @heap.size == 1
        raise IndexError.new("Cannot pop from empty queue")
      end

      min_value = @heap[1]
      swap(1, @heap.size - 1)
      @heap.pop
      bubble_down 1
      min_value[1]
    end

    def empty?
      @heap.size == 1
    end

    def size
      @heap.size - 1
    end

    def has_data?(needle)
      i = 1

      while i < @heap.size
        if @heap[i][1] == needle
          return true
        end

        i += 1
      end

      false
    end

    private def bubble_up(index)
      parent_index = index // 2

      return if parent_index.zero?

      child = @heap[index]
      parent = @heap[parent_index]

      if parent[0] > child[0]
        swap index, parent_index
        bubble_up parent_index
      end
    end

    private def bubble_down(index)
      left_child_index = index * 2
      right_child_index = index * 2 + 1

      return if left_child_index >= @heap.size

      lesser_child_index = determine_lesser_child(left_child_index, right_child_index)

      if @heap[index][0] > @heap[lesser_child_index][0]
        swap index, lesser_child_index
        bubble_down lesser_child_index
      end
    end

    private def determine_lesser_child(left_child_index, right_child_index)
      return left_child_index if right_child_index > @heap.size - 1

      if @heap[left_child_index][0] < @heap[right_child_index][0]
        left_child_index
      else
        right_child_index
      end
    end

    private def swap(index_a, index_b)
      @heap[index_a], @heap[index_b] = @heap[index_b], @heap[index_a]
    end
  end

  private def parse(input)
    input.split(',').map { |n| n.to_i64 }
  end

  private def run(vm)
    while !vm.halted?
      begin
        vm.step
      rescue IntcodeMissingInputError
        break
      end
    end
  end

  private def run_until_input_needed(vm)
    while !vm.halted?
      begin
        vm.step
      rescue IntcodeMissingInputError
        break
      end
    end
  end

  private def run_until_outputted(vm)
    initial_output_size = vm.size

    while !vm.halted?
      step

      if vm.outputs.size > initial_output_size
        break
      end
    end
  end

  private def generate_map(initial_vm, max_distance)
    # Use a queue-based flood-fill to generate the map.
    pos = Point.new
    map = {pos => 'D'}

    # run_until_input_needed(initial_vm)
    run(initial_vm)

    queue = [
      {initial_vm.clone, 1.to_i64, pos, pos.up},
      {initial_vm.clone, 2.to_i64, pos, pos.down},
      {initial_vm.clone, 3.to_i64, pos, pos.left},
      {initial_vm.clone, 4.to_i64, pos, pos.right},
    ]

    while !queue.empty?
      vm, input_val, from, to = queue.shift

      if map.has_key?(to) || vm.halted? || to.x.abs > max_distance || to.y.abs > max_distance
        next
      end

      vm << input_val
      run(vm)
      # run_until_outputted(vm)

      if vm.outputs.size != 1
        raise Exception.new("Unexpected output size #{vm.outputs.size}")
      end

      # next if vm.outputs.empty?

      output = vm.outputs.shift

      if output.zero?
        map[to] = '#'
      else
        map[to] = output == 1 ? '.' : 'X'
        queue << {vm.clone, 1.to_i64, to, to.up}
        queue << {vm.clone, 2.to_i64, to, to.down}
        queue << {vm.clone, 3.to_i64, to, to.left}
        queue << {vm.clone, 4.to_i64, to, to.right}
      end

      # case vm.outputs.shift
      # when 0
      #   map[to] = '#'
      #   # queue << {vm.clone, 1.to_i64, from, from.up}
      #   # queue << {vm.clone, 2.to_i64, from, from.down}
      #   # queue << {vm.clone, 3.to_i64, from, from.left}
      #   # queue << {vm.clone, 4.to_i64, from, from.right}
      # when 1
      #   map[to] = '.'
      #   queue << {vm.clone, 1.to_i64, to, to.up}
      #   queue << {vm.clone, 2.to_i64, to, to.down}
      #   queue << {vm.clone, 3.to_i64, to, to.left}
      #   queue << {vm.clone, 4.to_i64, to, to.right}
      # when 2
      #   map[to] = 'X'
      #   queue << {vm.clone, 1.to_i64, to, to.up}
      #   queue << {vm.clone, 2.to_i64, to, to.down}
      #   queue << {vm.clone, 3.to_i64, to, to.left}
      #   queue << {vm.clone, 4.to_i64, to, to.right}
      # else
      #   raise Exception.new "Invalid output value"
      # end
    end

    map
  end

  # def generate_map2(initial_vm)
  #   # Use BFS to generate the map.
  #   pos = Point.new
  #   map = {pos => 'D'}

  #   run(initial_vm)

  #   queue = [
  #     {initial_vm.clone, 1.to_i64, pos, pos.up},
  #     {initial_vm.clone, 2.to_i64, pos, pos.down},
  #     {initial_vm.clone, 3.to_i64, pos, pos.left},
  #     {initial_vm.clone, 4.to_i64, pos, pos.right},
  #   ]

  #   while !queue.empty?
  #     vm, input_val, from, to = queue.shift


  #   end
  # end

  def shortest_path(map, from, to) : Array(Point)
    # Dijkstra
    origin = Point.new
    distances = {origin => 0}
    prev = {} of Point => Point
    queue = PriorityQueue.new

    queue.push(0, origin)

    while !queue.empty?
      min_dist_point = queue.pop

      neighbors = [
        min_dist_point.up,
        min_dist_point.down,
        min_dist_point.left,
        min_dist_point.right,
      ].select { |p| map.has_key?(p) && map[p] != '#' }

      neighbors.each do |neighbor|
        alt = distances[min_dist_point] + min_dist_point.manhattan_distance(neighbor)

        if alt < distances.fetch(neighbor, Int32::MAX)
          distances[neighbor] = alt
          prev[neighbor] = min_dist_point

          if !queue.has_data? neighbor
            queue.push(alt, neighbor)
          end
        end
      end
    end

    path = [] of Point
    target = to

    while !target.nil?
      path.unshift target
      target = prev[target]?
    end

    path
  end

  def name
    "2019 Day 15: Oxygen System"
  end

  def part1(input)
    max_distance = 450
    memory = parse input
    vm = Intcode.new memory
    map = generate_map(vm, max_distance)
    start = Point.new
    dest = map.key_for? 'X'
    # min_steps = Int32::MAX
    # oxygen_locs = map.each.select { |kv| kv[1] == 'X' }

    # map.each do |key, val|
    #   if val == 'X'
    #     path = shortest_path(map, start, key)
    #     steps = path.size - 1

    #     if steps < min_steps
    #       min_steps = steps
    #       puts min_steps
    #     end
    #   end
    # end
    path = shortest_path(map, start, dest)
    # path = shortest_path(map, start, closest_oxy[0])

    # min_steps
    path[1..-2].each do |p|
      map[p] = '@'
    end
    # # puts path[0].inspect
    # # puts path[-1].inspect
    puts path.size

    (-max_distance..max_distance).each do |y|
      puts (-max_distance..max_distance).map { |x| map.fetch(Point.new(x, y), ' ') }.join
      # line = ""

      # (-max_distance..max_distance).each do |x|
      #   pos = Point.new x, y
      #   line += map.fetch(pos, ' ')
      # end

      # puts line
    end
  end

  def part2(input)
    nil
  end
end
