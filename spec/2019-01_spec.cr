require "spec"
require "../src/advent2019_01.cr"

describe Advent2019_01 do
  describe "#part1" do
    it "should solve example input" do
      Advent2019_01.part1("12\n14\n1969\n100756").should eq 34241
    end
  end

  describe "#part2" do
    it "should solve example input" do
      Advent2019_01.part2("12\n14\n1969\n100756").should eq 51316
    end
  end
end
