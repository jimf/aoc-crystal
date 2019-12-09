require "./src/advent2019_01.cr"
require "./src/advent2019_02.cr"
require "./src/advent2019_03.cr"
require "./src/advent2019_04.cr"
require "./src/advent2019_05.cr"
require "./src/advent2019_06.cr"
require "./src/advent2019_07.cr"

mod = Advent2019_07

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
          else Advent2019_07
          end
end

input = ARGF.gets_to_end
puts "--- #{mod.name} ---"
puts "Part 1: #{mod.part1(input)}"
puts "Part 2: #{mod.part2(input)}"
