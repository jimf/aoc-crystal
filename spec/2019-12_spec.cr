require "spec"
require "../src/advent2019_12.cr"

describe Advent2019_12 do
  describe "#part1" do
    it "should solve example input" do
      test = <<-TEST
      <x=-1, y=0, z=2>
      <x=2, y=-10, z=-7>
      <x=4, y=-8, z=8>
      <x=3, y=5, z=-1>
      TEST
      Advent2019_12.part1(test, 10).should eq 179

      test = <<-TEST
      <x=-8, y=-10, z=0>
      <x=5, y=5, z=10>
      <x=2, y=-7, z=3>
      <x=9, y=-8, z=-3>
      TEST
      Advent2019_12.part1(test, 100).should eq 1940
    end
  end

  describe "#part2" do
    it "should solve example input" do
      test = <<-TEST
      <x=-1, y=0, z=2>
      <x=2, y=-10, z=-7>
      <x=4, y=-8, z=8>
      <x=3, y=5, z=-1>
      TEST
      Advent2019_12.part2(test).should eq 2772
    end
  end
end
