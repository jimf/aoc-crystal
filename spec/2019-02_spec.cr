require "spec"
require "../src/advent2019_02.cr"

describe Advent2019_02 do
  describe "#part1" do
    it "should solve example input" do
      Advent2019_02.part1("1,9,10,3,2,3,11,0,99,30,40,50", false).should eq 3500
      Advent2019_02.part1("1,0,0,0,99", false).should eq 2
      Advent2019_02.part1("2,3,0,3,99", false).should eq 2
      Advent2019_02.part1("2,4,4,5,99,0", false).should eq 2
      Advent2019_02.part1("1,1,1,4,99,5,6,0,99", false).should eq 30
    end
  end
end
