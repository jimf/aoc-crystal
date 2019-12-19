require "./point.cr"

module Advent2019_03
  extend self

  private def parse(input)
    input.lines().map do |line|
      line.split(',').map { |mv| {dir: mv[0], len: mv[1..].to_i()} }
    end
  end

  private def move(point, dir)
    case dir
    when 'U' then point.up
    when 'D' then point.down
    when 'L' then point.left
    when 'R' then point.right
    else point
    end
  end

  private def line_points(line)
    current = Point.new(0, 0)
    points = [current]

    line.each do |move|
      move[:len].times do
        current = move(current, move[:dir])
        points << current
      end
    end

    points
  end

  def name
    "2019 Day 3: Crossed Wires"
  end

  def part1(input)
    lines = parse(input)
    line1 = line_points(lines[0])
    line2 = line_points(lines[1])
    origin = Point.new(0, 0)
    intersects = (Set.new(line1) - Set{origin}) & Set.new(line2)
    (intersects.to_a.map { |p| p.manhattan_distance(origin) }).min
  end

  def part2(input)
    lines = parse(input)
    line1 = line_points(lines[0])
    line2 = line_points(lines[1])
    origin = Point.new(0, 0)
    intersects = (Set.new(line1) - Set{origin}) & Set.new(line2)
    (intersects.to_a.map do |point|
      line1_distance = line1.index point
      line2_distance = line2.index point
      if line1_distance.nil? || line2_distance.nil?
        0
      else
        line1_distance + line2_distance
      end
    end).min
  end
end
