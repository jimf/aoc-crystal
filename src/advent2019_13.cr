require "./intcode.cr"

module Advent2019_13
  extend self

  private def run(memory)
    vm = Intcode.new(memory, [] of Int64)

    while !vm.halted
      vm.step
    end

    vm.outputs
  end

  private def parse(input)
    input.split(',').map { |n| n.to_i64 }
  end

  def name
    "2019 Day 13: Care Package"
  end

  def part1(input)
    unique_block_tiles = Set.new [] of Tuple(Int64, Int64)
    run(parse input).each_slice(3) do |xyt|
      x, y, tile = xyt

      if tile == 2 # block tile
        unique_block_tiles << {x, y}
      else
        unique_block_tiles.delete({x, y})
      end
    end

    unique_block_tiles.size
  end

  # def part2(input)
  #   score = -1
  #   input_values = [] of Int64
  #   runs = 0

  #   while score <= 0
  #     memory = parse input
  #     memory[0] = 2.to_i64
  #     run_input_values = input_values.dup
  #     vm = Intcode.new(memory, input_values.dup)
  #     inputs_added = 0
  #     idx = 0
  #     paddle_x = 0.to_i64
  #     ball_x = 0.to_i64

  #     while !vm.halted
  #       begin
  #         vm.step
  #       rescue IntcodeMissingInputError
  #         # puts "ballx: #{ball_x}; paddlex: #{paddle_x}; #{(ball_x <=> paddle_x)}"
  #         # vm << (ball_x <=> paddle_x).to_i64
  #         val = rand(-1..1).to_i64
  #         # print "#{val} "
  #         run_input_values << val
  #         vm << val
  #         inputs_added += 1
  #       end

  #       # while idx < vm.outputs.size - 3
  #       #   tile_id = vm.outputs[idx + 2]

  #       #   if tile_id == 3 # paddle
  #       #     paddle_x = vm.outputs[idx]
  #       #   elsif tile_id == 4 # ball
  #       #     ball_x = vm.outputs[idx]
  #       #   end

  #       #   idx += 3
  #       # end
  #     end

  #     # if inputs_added > run_input_values.size / 2
  #     #   input_values = run_input_values[0..run_input_values.size // 2]
  #     # end

  #     if inputs_added > 0
  #       input_values = run_input_values
  #       input_values.pop Math.log2(input_values.size).to_i
  #     end

  #     if input_values.size < 4
  #       input_values.clear
  #     end

  #     score = -1
  #     vm.outputs.each_slice(3) do |slice|
  #       if slice[0] == -1 && slice[1] == 0
  #         score = slice[2]
  #       end
  #     end

  #     runs += 1

  #     if runs % 256 == 0
  #       # puts "#{input_values.size}; #{Math.log2(input_values.size)}"
  #       input_values.pop(2 * Math.log2(input_values.size).to_i + 1)
  #       puts input_values.size
  #     end

  #     if runs & 1024 == 0
  #       input_values.pop(input_values.size // 4)
  #     end
  #   end

  #   score
  # end

  def part2(input)
    memory = parse input
    memory[0] = 2.to_i64
    vm = Intcode.new(memory, [] of Int64)
    # vm = Intcode.new(memory, [0.to_i64])
    output_idx = 0
    paddle_pos = {0.to_i64, 0.to_i64}
    ball_pos = {0.to_i64, 0.to_i64}
    score = -1

    while !vm.halted
      begin
        vm.step
      rescue IntcodeMissingInputError
        # puts "ballx: #{ball_x}; paddlex: #{paddle_x}; #{(ball_x <=> paddle_x)}"
        # vm << (ball_x <=> paddle_x).to_i64
        puts "ball: #{ball_pos}; paddle: #{paddle_pos}; #{(ball_pos[0] <=> paddle_pos[0])}"
        vm << (ball_pos[0] <=> paddle_pos[0]).to_i64
      end

      while output_idx < vm.outputs.size - 3
        tile_id = vm.outputs[output_idx + 2]

        if vm.outputs[output_idx] == -1 && vm.outputs[output_idx + 1] == 0 && vm.outputs[output_idx + 2] > score
          score = vm.outputs[output_idx + 2]
        elsif tile_id == 3 # paddle
          # paddle_x = vm.outputs[output_idx]
          paddle_pos = {vm.outputs[output_idx], vm.outputs[output_idx + 1]}
        elsif tile_id == 4 # ball
          # ball_x = vm.outputs[output_idx]
          ball_pos = {vm.outputs[output_idx], vm.outputs[output_idx + 1]}
        end

        output_idx += 3
      end
    end

    puts "ball: #{ball_pos}; paddle: #{paddle_pos}; #{(ball_pos[0] <=> paddle_pos[0])}"
    score
  end
end
