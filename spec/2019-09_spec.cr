require "spec"
require "../src/advent2019_09.cr"

describe Advent2019_09 do
  describe "#part1" do
    it "should solve example input" do
      ex1 = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
      Advent2019_09.part1(ex1, [] of Int32).should eq ex1.split(',').map { |n| n.to_i }
    end
  end
end
