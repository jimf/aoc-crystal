require "spec"
require "../src/advent2019_16.cr"

describe Advent2019_16 do
  describe "#part1" do
    it "should solve example input" do
      Advent2019_16.part1("12345678", 4).should eq "01029498"
    end
  end
end
