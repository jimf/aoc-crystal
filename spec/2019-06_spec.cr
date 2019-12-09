require "spec"
require "../src/advent2019_06.cr"

describe Advent2019_06 do
  describe "#part1" do
    it "should solve example input" do
      Advent2019_06.part1("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L").should eq 42
    end
  end

  describe "#part2" do
    it "should solve example input" do
      Advent2019_06.part2("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN").should eq 4
    end
  end
end
