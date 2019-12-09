require "./intcode"

module Advent2019_02
  extend self

  private def parse(input)
    input.split(',').map { |n| n.to_i() }
  end

  private def run(memory)
    vm = Intcode.new(memory, [0])
    while !vm.halted
      vm.step
    end

    vm.mem0
  end

  def name
    "2019 Day 2: 1202 Program Alarm"
  end

  def part1(input, restore_state = true)
    initial_memory = parse(input)

    if restore_state
      initial_memory[1] = 12
      initial_memory[2] = 2
    end

    run initial_memory
  end

  def part2(input)
    pair = (0..99).to_a.each_permutation(2).find do |(noun, verb)|
      memory = parse(input)
      memory[1] = noun
      memory[2] = verb
      run(memory) == 19690720
    end
    if pair
      100 * pair[0] + pair[1]
    else
      nil
    end
  end
end
