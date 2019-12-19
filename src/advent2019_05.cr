require "./intcode"

module Advent2019_05
  extend self

  private def parse(input)
    input.split(',').map { |n| n.to_i64() }
  end

  private def run(memory, input_values)
    vm = Intcode.new(memory, input_values)
    while !vm.halted?
      vm.step
    end

    vm.outputs
  end

  def name
    "2019 Day 5: Sunny with a Chance of Asteroids"
  end

  def part1(input, input_values = [1.to_i64])
    run(parse(input), input_values)
  end

  def part2(input, input_values = [5.to_i64])
    run(parse(input), input_values)
  end
end
