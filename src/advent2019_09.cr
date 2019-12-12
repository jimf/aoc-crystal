require "./intcode.cr"

module Advent2019_09
  extend self

  private def parse(input)
    input.split(',').map { |n| n.to_i }
  end

  private def run(memory, input_values)
    vm = Intcode.new(memory, input_values)
    while !vm.halted
      vm.step
    end

    vm.outputs
  end

  def name
    "2019 Day 9: Sensor Boost"
  end

  def part1(input, input_values = [1])
    run parse(input), input_values
  end

  def part2(input)
    nil
  end
end
