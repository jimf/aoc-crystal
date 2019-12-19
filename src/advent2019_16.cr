module Advent2019_16
  extend self

  private class RepeatingPattern
    include Iterator(Int32)

    def initialize(@number : Int32)
      @i = 0
      @times = 1
      @base_pattern = [0, 1, 0, -1]
    end

    def next
      if @times == @number
        @i = (@i + 1) % 4
        @times = 0
      end

      @times += 1
      return @base_pattern[@i]
    end
  end

  private def parse(input)
    input.chomp.chars.map { |n| n.to_i }
  end

  private def fft(input)
    result = Array.new input.size, 0
    base_pattern = [0, 1, 0, -1]
    i = 0

    while i < result.size
      repeat_pattern = RepeatingPattern.new(i + 1)
      sum = 0

      input.each do |n|
        rp = repeat_pattern.next

        if rp != 0
          sum += n * rp
        end
      end

      result[i] = sum.abs % 10
      i += 1
    end

    result
  end

  private def fft2(input)
    result = Array.new(input.size * 10000, 0)
    base_pattern = [0, 1, 0, -1]
    i = 0

    while i < result.size
      repeat_pattern = RepeatingPattern.new(i + 1)
      sum = 0

      input.each do |n|
        rp = repeat_pattern.next

        if rp != 0
          sum += n * rp
        end
      end

      result[i] = (sum.abs * 10000) % 10
      i += 1
    end

    result
  end

  def name
    "2019 Day 16: Flawed Frequency Transmission"
  end

  def part1(input, phases = 100)
    digits = parse input

    phases.times do
      digits = fft digits
    end

    digits[0..7].join
  end

  def part2(input, phases = 100)
    # digits = parse(input.chomp * 10000)
    digits = parse input
    phases.times do
      digits = fft2 digits
      puts digits[0..7].join
    end

    digits[0..7].join
  end
end
