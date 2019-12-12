require "./src/advent2019_01.cr"
require "./src/advent2019_02.cr"
require "./src/advent2019_03.cr"
require "./src/advent2019_04.cr"
require "./src/advent2019_05.cr"
require "./src/advent2019_06.cr"
require "./src/advent2019_07.cr"
require "./src/advent2019_08.cr"
require "./src/advent2019_09.cr"
require "./src/advent2019_10.cr"
require "./src/advent2019_11.cr"
require "./src/advent2019_12.cr"

mod = Advent2019_12

if ARGV.size > 0
    arg = ARGV.shift
    mod = case arg
          when "2019-01" then Advent2019_01
          when "2019-02" then Advent2019_02
          when "2019-03" then Advent2019_03
          when "2019-04" then Advent2019_04
          when "2019-05" then Advent2019_05
          when "2019-06" then Advent2019_06
          when "2019-07" then Advent2019_07
          when "2019-08" then Advent2019_08
          when "2019-09" then Advent2019_09
          when "2019-10" then Advent2019_10
          when "2019-11" then Advent2019_11
          when "2019-12" then Advent2019_12
          else Advent2019_12
          end
end

input = ARGF.gets_to_end
puts "--- #{mod.name} ---"
puts "Part 1: #{mod.part1(input)}"
puts "Part 2: #{mod.part2(input)}"
