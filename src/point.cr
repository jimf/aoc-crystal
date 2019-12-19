class Point
  getter x : Int32
  getter y : Int32

  def initialize(@x = 0, @y = 0)
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def hash
    {@x, @y}.hash
  end

  def up(n = 1)
    Point.new(@x, @y - n)
  end

  def down(n = 1)
    Point.new(@x, @y + n)
  end

  def left(n = 1)
    Point.new(@x - n, @y)
  end

  def right(n = 1)
    Point.new(@x + n, @y)
  end

  def manhattan_distance(other)
    (@x - other.x).abs + (@y - other.y).abs
  end
end
