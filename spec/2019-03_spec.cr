require "spec"
require "../src/advent2019_03.cr"

describe Advent2019_03 do
  describe "#part1" do
    it "should solve example input" do
      Advent2019_03.part1("R8,U5,L5,D3\nU7,R6,D4,L4").should eq 6
      Advent2019_03.part1("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83").should eq 159
      Advent2019_03.part1("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7").should eq 135
    end
  end

  describe "#part2" do
    it "should solve example input" do
      Advent2019_03.part2("R8,U5,L5,D3\nU7,R6,D4,L4").should eq 30
      Advent2019_03.part2("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83").should eq 610
      Advent2019_03.part2("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7").should eq 410
    end
  end
end
