module Graph
  class Point

    attr_accessor :x, :y

    def initialize(_x, _y)
      self.x = Float _x
      self.y = Float _y
    end

    def -(_point)
     difference_x = self.x - _point.x
     difference_y = self.y - _point.y  
     Point.new(difference_x, difference_y)
    end

    def +(_point)
      sum_x = self.x + _point.x
      sum_y = self.y + _point.y
      Point.new(sum_x, sum_y)
    end

    def ==(_point)
      return (self.x == _point.x && self.y == _point.y)
    end

    def to_s
      "(#{self.x}, #{self.y})"
    end

    def slope(_point)
      difference = self - _point
      difference.y / difference.x
    end

    def distance_to_point(_point)
      return Math.sqrt((_point.x - self.x)**2 + (_point.y - self.y)**2)
    end

    def distance_to_line(_line)
      return _line.distance_to_point(self)
    end
  end
end
