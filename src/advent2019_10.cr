module Advent2019_10
  extend self

  # Bresenham's Line Algorithm
  # Returns the list of coordinates between points a and b.
  def get_line(x0, y0, x1, y1)
    result = [] of {x: Int32, y: Int32}
    is_steep = (y1 - y0).abs > (x1 - x0).abs

    if is_steep
      x0, y0 = y0, x0
      x1, y1 = y1, x1
    end

    is_flipped = false
    if x0 > x1
      x0, x1 = x1, x0
      y0, y1 = y1, y0
      is_flipped = true
    end

    deltax = x1 - x0
    deltay = (y1 - y0).abs
    error = deltax // 2
    ystep = y0 < y1 ? 1 : -1
    y = y0

    (x0..x1).each do |x|
      if is_steep
        result << {x: y, y: x}
      else
        result << {x: x, y: y}
      end

      error -= deltay

      if error < 0
        y += ystep
        error += deltax
      end
    end

    is_flipped ? result.reverse : result
  end

  private def scale(grid, n = 1)
    result = [] of Array(Char)

    grid.each do |row|
      n.times do
        result << Array.new(((n * 2) + 1) * grid.size, '.')
      end

      new_row = [] of Char
      row.each do |col|
        n.times do
          new_row << '.'
        end

        new_row << col

        n.times do
          new_row << '.'
        end
      end

      result << new_row

      n.times do
        result << Array.new(((n * 2) + 1) * grid.size, '.')
      end
    end

    result
  end

  private class Perimeter
    include Iterator(NamedTuple(x: Int32, y: Int32))

    def initialize(@size : Int32, @start = {x: 0, y: 0})
      @next = start
      @started = false
    end

    def next
      if @next == @start && @started
        return stop
      end

      @started = true
      result = @next
      x = result[:x]
      y = result[:y]

      if x < @size - 1 && y == 0
        x += 1
      elsif y < @size - 1 && x == @size - 1
        y += 1
      elsif x > 0 && y == @size - 1
        x -= 1
      else
        y -= 1
      end

      @next = {x: x, y: y}
      result
    end
  end

  private def parse(input)
    input.lines.map { |line| line.chars }
  end

  def name
    "2019 Day 10: Monitoring Station"
  end

  def part1(input, scale_factor = 8)
    # Approach: For every asteroid, iterate over the perimeter of the grid, determining
    # every line from the the asteroid to the outer perimeter. Following each line,
    # find the first asteroid along that line and stop. Given that asteroids take up
    # less space than the grid indicates, use a scale factor to pad out the asteroids
    # with extra space, adding better resolution to the algorithm.
    world = scale parse(input), scale_factor
    result = 0

    # boundaries = ((0...world.size).map { |i| [
    #   {x: i, y: 0},
    #   {x: i, y: world.size - 1},
    #   {x: 0, y: i},
    #   {x: world.size - 1, y: i},
    # ] }).flatten

    (0...world.size).each do |y|
      (0...world.size).each do |x|
        if world[y][x] == '#'
          in_los = Set.new [] of NamedTuple(x: Int32, y: Int32)

          Perimeter.new(world.size).each do |b|
            if !(b[:x] == x && b[:y] == y)
              line = get_line x, y, b[:x], b[:y]
              first_in_los = line.find { |p| world[p[:y]][p[:x]] == '#' && !(p[:x] == x && p[:y] == y) }

              if !first_in_los.nil?
                in_los << first_in_los
              end
            end
          end

          result = [result, in_los.size].max
        end
      end
    end

    result
  end

  def part2(input, scale_factor = 8)
    # This isn't working. I know the result for my input is > 1420 and != 1920.
    # I'm missing something, but this isn't fun. Moving on.
    world = scale parse(input), scale_factor
    max = 0
    pos = {x: 0, y: 0}

    (0...world.size).each do |y|
      (0...world.size).each do |x|
        if world[y][x] == '#'
          in_los = Set.new [] of NamedTuple(x: Int32, y: Int32)

          Perimeter.new(world.size).each do |b|
            if !(b[:x] == x && b[:y] == y)
              line = get_line x, y, b[:x], b[:y]
              first_in_los = line.find { |p| world[p[:y]][p[:x]] == '#' && !(p[:x] == x && p[:y] == y) }

              if !first_in_los.nil?
                in_los << first_in_los
              end
            end
          end

          if in_los.size > max
            max = in_los.size
            pos = {x: x, y: y}
          end
        end
      end
    end

    num_vaporized = 0
    ast_200 = {x: 0, y: 0}

    puts "Base: #{pos[:x] // ((2 * scale_factor) + 1)},#{pos[:y] // ((2 * scale_factor) + 1)}"

    while num_vaporized < 200
      Perimeter.new(world.size, {x: pos[:x], y: 0}).each do |b|
        line = get_line pos[:x], pos[:y], b[:x], b[:y]
        first_in_los = line.find { |p| world[p[:y]][p[:x]] == '#' && p != pos }

        if !first_in_los.nil?
          num_vaporized += 1
          world[first_in_los[:y]][first_in_los[:x]] = '.'

          ux = first_in_los[:x] // ((2 * scale_factor) + 1)
          uy = first_in_los[:y] // ((2 * scale_factor) + 1)
          # puts "Asteroid #{num_vaporized} vaporized at #{ux},#{uy} [boundary: #{b}]"

          if num_vaporized == 200
            ast_200 = first_in_los
            break
          end
        end
      end
    end

    unscaled_x = ast_200[:x] // ((2 * scale_factor) + 1)
    unscaled_y = ast_200[:y] // ((2 * scale_factor) + 1)

    (unscaled_x * 100) + unscaled_y
  end
end
