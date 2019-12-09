require "./intcode"

module Advent2019_05
  extend self

  private def parse(input)
    input.split(',').map { |n| n.to_i() }
  end

  private def run(memory, input_value)
    vm = Intcode.new(memory, input_value)
    while !vm.halted
      vm.step
    end

    vm.outputs
  end

  def name
    "2019 Day 5: Sunny with a Chance of Asteroids"
  end

  def part1(input, input_value = 1)
    run(parse(input), input_value)
  end

  def part2(input, input_value = 5)
    run(parse(input), input_value)
  end
end
