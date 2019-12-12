class IntcodeMissingInputError < Exception
end

class Intcode
  def initialize(memory : Array(Int32), input_values : Array(Int32))
    @pc = 0
    @rb = 0
    @memory = memory
    @input_values = input_values
    @outputs = [] of Int32
    @halted = false
  end

  private def param(n)
    mod = 100 * 10 ** n
    mode = (read_mem(@pc) % mod) // (mod / 10)
    case mode
    when 0 then read_mem @pc + n
    when 1 then read_mem @pc + n
    when 2 then @rb + read_mem(@pc + n)
    else -1
    end
  end

  private def value(n)
    mod = 100 * 10 ** n
    mode = (read_mem(@pc) % mod) // (mod / 10)
    case mode
    when 0 then read_mem param(n)
    when 1 then param(n)
    when 2 then read_mem param(n)
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
    case read_mem(@pc) % 100
    when 1 then add
    when 2 then mul
    when 3 then input
    when 4 then output
    when 5 then jump_if_true
    when 6 then jump_if_false
    when 7 then less_than
    when 8 then equals
    when 9 then adjust_rel_base
    when 99 then halt
    end
  end

  private def read_mem(i)
    result = @memory[i]?
    if result.nil?
      0
    else
      result
    end
  end

  private def write_mem(i, val)
    if i >= @memory.size
      @memory += Array.new(i - @memory.size + 1, 0)
    end
    @memory[i] = val
  end

  private def binop
    val = yield value(1), value(2)
    write_mem param(3), val
    @pc += 4
  end

  private def add
    binop { |a, b| a + b }
  end

  private def mul
    binop { |a, b| a * b }
  end

  private def input
    begin
      val = @input_values.shift
      write_mem param(1), val
      @pc += 2
    rescue IndexError
      raise IntcodeMissingInputError.new
    end
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

  private def adjust_rel_base
    @rb += value(1)
    @pc += 2
  end

  private def halt
    @halted = true
  end
end
