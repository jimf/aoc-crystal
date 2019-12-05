module Advent2019_05
  extend self

  private class VM
    def initialize(memory : Array(Int32), input_value : Int32)
      @pc = 0
      @memory = memory
      @input_value = input_value
      @outputs = [] of Int32
      @halted = false
    end

    private def param(n)
      @memory[@pc + n]
    end

    private def value(n)
      mod = 100 * 10 ** n
      mode = (@memory[@pc] % mod) // (mod / 10)
      case mode
      when 0 then @memory[param(n)]
      when 1 then param(n)
      else -1
      end
    end

    def outputs
      @outputs
    end

    def halted
      @halted
    end

    def step
      case @memory[@pc] % 100
      when 1 then add
      when 2 then mul
      when 3 then input
      when 4 then output
      when 5 then jump_if_true
      when 6 then jump_if_false
      when 7 then less_than
      when 8 then equals
      when 99 then halt
      end
    end

    def binop
      @memory[param(3)] = yield value(1), value(2)
      @pc += 4
    end

    def add
      binop { |a, b| a + b }
    end

    def mul
      binop { |a, b| a * b }
    end

    def input
      @memory[param(1)] = @input_value
      @pc += 2
    end

    def output
      @outputs << value(1)
      @pc += 2
    end

    def jump_if_true
      if value(1) != 0
        @pc = value(2)
      else
        @pc += 3
      end
    end

    def jump_if_false
      if value(1) == 0
        @pc = value(2)
      else
        @pc += 3
      end
    end

    def less_than
      binop { |a, b| a < b ? 1 : 0 }
    end

    def equals
      binop { |a, b| a == b ? 1 : 0 }
    end

    def halt
      @halted = true
    end
  end

  private def parse(input)
    input.split(',').map { |n| n.to_i() }
  end

  private def run(memory, input_value)
    vm = VM.new(memory, input_value)
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
