require "./intcode.cr"

module Advent2019_13
  extend self

  private def run(memory)
    vm = Intcode.new(memory, [] of Int64)

    while !vm.halted?
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

  def part2(input)
    memory = parse input
    memory[0] = 2.to_i64
    vm = Intcode.new(memory, [] of Int64)
    paddle_pos = {0.to_i64, 0.to_i64}
    ball_pos = {0.to_i64, 0.to_i64}
    score = -1

    while !vm.halted?
      begin
        vm.step
      rescue IntcodeMissingInputError
        vm << (ball_pos[0] <=> paddle_pos[0]).to_i64
      end

      if vm.outputs.size == 3
        x = vm.outputs.shift
        y = vm.outputs.shift
        tile = vm.outputs.shift

        if x == -1 && y == 0
          score = tile
        elsif tile == 3 # paddle
          paddle_pos = {x, y}
        elsif tile == 4 # ball
          ball_pos = {x, y}
        end
      end
    end

    score
  end
end
