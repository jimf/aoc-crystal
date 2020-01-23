require "./intcode.cr"
require "./turtle.cr"

module Advent2019_11
  extend self

  private def parse(input)
    input.split(',').map { |n| n.to_i64 }
  end

  def name
    "2019 Day 11: Space Police"
  end

  def part1(input)
    board = {} of Tuple(Int32, Int32) => Int64
    painted = {} of Tuple(Int32, Int32) => Int32
    inputs = [] of Int64
    vm = Intcode.new parse(input), inputs
    robot = Turtle.new

    while !vm.halted?
      pos = {robot.x, robot.y}
      inputs << board.fetch(pos, 0.to_i64)
      painted[pos] = painted.fetch(pos, 0) + 1

      while !vm.halted?
        begin
          vm.step
        rescue IntcodeMissingInputError
          break
        end
      end

      board[pos] = vm.outputs[-2]

      if vm.outputs[-1] == 0
        robot.left
      else
        robot.right
      end

      robot.forward
    end

    painted.size
  end

  def part2(input)
    board = {} of Tuple(Int32, Int32) => Int64
    painted = {} of Tuple(Int32, Int32) => Int32
    inputs = [] of Int64
    vm = Intcode.new parse(input), inputs
    robot = Turtle.new

    board[{0, 0}] = 1.to_i64

    while !vm.halted?
      pos = {robot.x, robot.y}
      inputs << board.fetch(pos, 0.to_i64)
      painted[pos] = painted.fetch(pos, 0) + 1

      while !vm.halted?
        begin
          vm.step
        rescue IntcodeMissingInputError
          break
        end
      end

      board[pos] = vm.outputs[-2]

      if vm.outputs[-1] == 0
        robot.left
      else
        robot.right
      end

      robot.forward
    end

    min_x = 0
    min_y = 0
    max_x = 0
    max_y = 0

    board.each do |key, val|
      x, y = key

      min_x = [min_x, x].min
      min_y = [min_y, y].min
      max_x = [max_x, x].max
      max_y = [max_y, y].max
    end

    deltax = 0 - min_x
    deltay = 0 - min_y

    result = Array.new max_y - min_y + 1, do
      Array.new max_x - min_x + 1, ' '
    end

    board.each do |key, value|
      x, y = key

      if value == 1
        result[deltay + y][deltax + x] = '#'
      end
    end

    '\n' + result.join('\n') { |row| row.join }
  end
end
