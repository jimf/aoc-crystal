module Advent2019_04
  extend self

  private def parse(input)
    parts = input.split('-')
    {min: parts[0].to_i(), max: parts[1].to_i()}
  end

  private def has_matching_adjacent_digits(n)
    n.to_s.chars.each_cons(2).any? { |cons| cons[0] == cons[1] }
  end

  private def has_increasing_digits(n)
    n.to_s.chars.each_cons(2).all? { |cons| cons[0] <= cons[1] }
  end

  private def has_pair_of_matching_digits(n)
    groups = n.to_s.chars.group_by { |c| c }
    groups.values.any? { |digits| digits.size == 2 }
  end

  def name
    "2019 Day 4: Secure Container"
  end

  def part1(input)
    input = parse input
    (input[:min]..input[:max]).count { |n| has_increasing_digits(n) && has_matching_adjacent_digits(n) }
  end

  def part2(input)
    input = parse input
    (input[:min]..input[:max]).count { |n| has_increasing_digits(n) && has_pair_of_matching_digits(n) }
  end
end
