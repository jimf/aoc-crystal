require "./intcode.cr"

module Advent2019_17
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
    "2019 Day 17: Set and Forget"
  end

  def part1(input)
    nil
  end

  def part2(input)
    nil
  end
end
