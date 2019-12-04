require "./src/advent2019_01.cr"
require "./src/advent2019_02.cr"
require "./src/advent2019_03.cr"
require "./src/advent2019_04.cr"

mod = Advent2019_04

if ARGV.size > 0
    arg = ARGV.shift
    mod = case arg
          when "2019-01" then Advent2019_01
          when "2019-02" then Advent2019_02
          when "2019-03" then Advent2019_03
          when "2019-04" then Advent2019_04
          else Advent2019_04
          end
end

input = ARGF.gets_to_end
puts "--- #{mod.name} ---"
puts "Part 1: #{mod.part1(input)}"
puts "Part 2: #{mod.part2(input)}"
