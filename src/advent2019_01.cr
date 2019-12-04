private def mass_to_fuel(mass)
  mass.tdiv(3) - 2
end

private def mass_to_fuel2(mass)
  return 0 if mass <= 6
  fuel = mass_to_fuel(mass)
  fuel + mass_to_fuel2(fuel)
end

module Advent2019_01
  extend self

  private def parse(input)
    input.lines.map { |line| line.to_i() }
  end

  def name
    "2019 Day 1: The Tyranny of the Rocket Equation"
  end

  def part1(input)
    self.parse(input).reduce(0) { |acc, mass| acc + mass_to_fuel(mass) }
  end

  def part2(input)
    self.parse(input).reduce(0) { |acc, mass| acc + mass_to_fuel2(mass) }
  end
end
