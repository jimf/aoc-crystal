# require "./point.cr"

module Advent2019_18
  extend self

  private def parse(input)
    input.lines.map { |line| line.chars }
  end

  def name
    "2019 Day 18: Many-Worlds Interpretation"
  end

  def part1(input)
    world = parse input
    doors = {} of Char => Tuple(Int32, Int32)
    keys = {} of Char => Tuple(Int32, Int32)

    world.each_with_index do |row, y|
      row.each_with_index do |ch, x|
        if ch >= 'A' && ch <= 'Z'
          doors[ch] = {x, y}
        elsif ch >= 'a' && ch <= 'z'
          keys[ch] = {x, y}
        end
      end
    end

    puts doors
    puts keys
  end

  def part2(input)
    nil
  end
end
