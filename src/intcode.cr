class Intcode
  def initialize(memory : Array(Int32), input_values : Array(Int32))
    @pc = 0
    @memory = memory
    @input_values = input_values
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

  def mem0
    @memory[0]
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

  private def binop
    @memory[param(3)] = yield value(1), value(2)
    @pc += 4
  end

  private def add
    binop { |a, b| a + b }
  end

  private def mul
    binop { |a, b| a * b }
  end

  private def input
    @memory[param(1)] = @input_values.shift
    @pc += 2
  end

  private def output
    @outputs << value(1)
    @pc += 2
  end

  private def jump_if_true
    if value(1) != 0
      @pc = value(2)
    else
      @pc += 3
    end
  end

  private def jump_if_false
    if value(1) == 0
      @pc = value(2)
    else
      @pc += 3
    end
  end

  private def less_than
    binop { |a, b| a < b ? 1 : 0 }
  end

  private def equals
    binop { |a, b| a == b ? 1 : 0 }
  end

  private def halt
    @halted = true
  end
end
