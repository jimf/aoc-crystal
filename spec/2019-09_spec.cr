require "spec"
require "../src/advent2019_09.cr"

describe Advent2019_09 do
  describe "#part1" do
    it "should solve example input" do
      ex1 = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
      Advent2019_09.part1(ex1, [] of Int64).should eq ex1.split(',').map { |n| n.to_i64 }
      Advent2019_09.part1("1102,34915192,34915192,7,4,7,99,0", [] of Int64).should eq [1219070632396864]
      Advent2019_09.part1("104,1125899906842624,99", [] of Int64).should eq [1125899906842624]
    end
  end
end
