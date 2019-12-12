module Advent2019_12
  extend self

  private class Coord
    getter x : Int32
    getter y : Int32
    getter z : Int32

    def initialize(@x = 0, @y = 0, @z = 0)
    end

    def hash
      {@x, @y, @z}.hash
    end

    def inspect
      "<x=#{@x}, y=#{@y}, z=#{@z}>"
    end

    def ==(other)
      @x == other.x && @y == other.y && @z == other.z
    end

    def +(other)
      Coord.new @x + other.x, @y + other.y, @z + other.z
    end

    def abs_sum
      @x.abs + @y.abs + @z.abs
    end
  end

  private def parse(input)
    input.lines.map do |line|
      match = line.match(/^<x=(-?\d+), y=(-?\d+), z=(-?\d+)>$/).not_nil!
      x, y, z = match.captures
      if !x.nil? && !y.nil? && !z.nil?
        [Coord.new(x.to_i, y.to_i, z.to_i), Coord.new]
      else
        [Coord.new, Coord.new]
      end
    end
  end

  def name
    "2019 Day 12: The N-Body Problem"
  end

  def part1(input, steps = 1000)
    moons = parse input

    steps.times do
      # Apply gravity
      moons.each_combination(2).each do |pair|
        a, b = pair

        if a[0].x > b[0].x
          a[1] += Coord.new(-1, 0, 0)
          b[1] += Coord.new(1, 0, 0)
        elsif a[0].x < b[0].x
          a[1] += Coord.new(1, 0, 0)
          b[1] += Coord.new(-1, 0, 0)
        end

        if a[0].y > b[0].y
          a[1] += Coord.new(0, -1, 0)
          b[1] += Coord.new(0, 1, 0)
        elsif a[0].y < b[0].y
          a[1] += Coord.new(0, 1, 0)
          b[1] += Coord.new(0, -1, 0)
        end

        if a[0].z > b[0].z
          a[1] += Coord.new(0, 0, -1)
          b[1] += Coord.new(0, 0, 1)
        elsif a[0].z < b[0].z
          a[1] += Coord.new(0, 0, 1)
          b[1] += Coord.new(0, 0, -1)
        end
      end

      # Apply velocity
      moons.each do |moon|
        moon[0] += moon[1]
      end
    end

    moons.sum(0) { |moon| moon[0].abs_sum * moon[1].abs_sum}
  end

  def part2(input)
    # Approach: Watch the x/y/z coordinates separately for a cycle. Once a
    # cycle has been found for every dimension, calculate the least common
    # multiple of all three periods.
    moons = parse input
    initial = moons.map { |moon| [moon[0], moon[1]] }
    steps = 0
    period = Array.new(3, -1.to_i64)

    loop do
      # Apply gravity
      moons.each_combination(2).each do |pair|
        a, b = pair

        if a[0].x > b[0].x
          a[1] += Coord.new(-1, 0, 0)
          b[1] += Coord.new(1, 0, 0)
        elsif a[0].x < b[0].x
          a[1] += Coord.new(1, 0, 0)
          b[1] += Coord.new(-1, 0, 0)
        end

        if a[0].y > b[0].y
          a[1] += Coord.new(0, -1, 0)
          b[1] += Coord.new(0, 1, 0)
        elsif a[0].y < b[0].y
          a[1] += Coord.new(0, 1, 0)
          b[1] += Coord.new(0, -1, 0)
        end

        if a[0].z > b[0].z
          a[1] += Coord.new(0, 0, -1)
          b[1] += Coord.new(0, 0, 1)
        elsif a[0].z < b[0].z
          a[1] += Coord.new(0, 0, 1)
          b[1] += Coord.new(0, 0, -1)
        end
      end

      # Apply velocity
      is_eql_x = true
      is_eql_y = true
      is_eql_z = true
      moons.each_with_index do |moon, i|
        moon[0] += moon[1]

        is_eql_x = is_eql_x && moon[0].x == initial[i][0].x && moon[1].x == initial[i][1].x
        is_eql_y = is_eql_y && moon[0].y == initial[i][0].y && moon[1].y == initial[i][1].y
        is_eql_z = is_eql_z && moon[0].z == initial[i][0].z && moon[1].z == initial[i][1].z
      end

      steps += 1

      if is_eql_x && period[0] == -1
        period[0] = steps.to_i64
      end

      if is_eql_y && period[1] == -1
        period[1] = steps.to_i64
      end

      if is_eql_z && period[2] == -1
        period[2] = steps.to_i64
      end

      if period.all? { |n| n != -1 }
        break
      end
    end

    period.reduce { |x, y| x.lcm(y) }
  end
end
