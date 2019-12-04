module Advent2019_02
  extend self

  private class VM
    def initialize(memory : Array(Int32))
      @pc = 0
      @memory = memory
    end

    def mem0
      @memory[0]
    end

    def next
      opcode = @memory[@pc]
      @pc += 4
      opcode
    end

    def add
      @memory[@memory[@pc - 1]] = @memory[@memory[@pc - 3]] + @memory[@memory[@pc - 2]]
    end

    def mul
      @memory[@memory[@pc - 1]] = @memory[@memory[@pc - 3]] * @memory[@memory[@pc - 2]]
    end
  end

  private def parse(input)
    input.split(',').map { |n| n.to_i() }
  end

  private def run(memory)
    vm = VM.new memory
    opcode = vm.next

    loop do
      case opcode
      when 1 then vm.add
      when 2 then vm.mul
      when 99 then break
      end

      opcode = vm.next
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
