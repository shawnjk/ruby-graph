module Graph
  class Line
    attr_reader :x_intercept, :y_intercept

    def self.calculate_with_points(_point_a, _point_b)
      raise ArgumentError, "Points must be distinct" if _point_a == _point_b
      line = Line.new
      slope = _calculate_slope(_point_a, _point_b)
      line.instance_eval { _set_slope(slope) }
      if slope == 0.0
        line.x_intercept = nil
        line.y_intercept = Point.new(0, _point_a.y) 
      elsif slope.nil?
          line.x_intercept = Point.new(_point_a.x, 0.0)
          line.y_intercept = nil
      else
        line.y_intercept = _calculate_y_intercept(slope, _point_a)
        line.x_intercept = _calculate_x_intercept(slope, _point_a)
      end
      return line
    end

    def self.calculate_with_intercepts(_x_intercept,  _y_intercept)
      line = Line.new
      slope = _x_intercept.nil? || _y_intercept.nil? ? 0.0 : _calculate_slope(_x_intercept, _y_intercept)
      line.instance_eval { _set_slope(slope) }
      line.x_intercept = _x_intercept
      line.y_intercept = _y_intercept
      return line
    end

    def self.calculate_with_slope_and_point(_slope, _point)
      #raise ArgumentError, "Cannot calculate a line given a 0 slope and a 1 point" if _slope == 0
      line = Line.new
      line.instance_eval { _set_slope(_slope) }
      line.x_intercept = _calculate_x_intercept(_slope, _point)
      line.y_intercept = _calculate_y_intercept(_slope, _point) 
      return line
    end

    def distance_to_point(_point)
      if self.slope == 0.0
        if self.x_intercept.nil?
          return (_point.y - self.y_intercept.y).abs
        else
          return (_point.x - self.x_intercept.x).abs
        end
      end
      perpendicular_slope = -1 * self.slope**-1
      perpendicular_line = Line.calculate_with_slope_and_point(perpendicular_slope, _point)
      nearest_point = self.intersection(perpendicular_line)
      nearest_point.distance_to_point(_point)
    end

    def intersection(_line)
      if _line.x_intercept.nil?
        if self.x_intercept.nil?
          raise ArgumentError, "Intersection cannot be found -- lines are parallel"
        elsif self.y_intercept.nil?
          return Point.new(self.x_intercept.x, _line.y_intercept.y) 
        else
          intersect_x = (_line.y_intercept.y - self.y_intercept.y) / self.slope
          return Point.new(intersect_x, _line.y_intercept.y)
        end
      elsif _line.y_intercept.nil?
        if self.y_intercept.nil?
          raise ArgumentError, "Intersection cannot be found -- lines are parallel"
        elsif self.x_intercept.nil?
          return Point.new(_line.x_intercept.x, self.y_intercept.y)
        else
          intersect_y = self.slope * _line.x_intercept.x + self.y_intercept.y
          return Point.new(_line.x_intercept.x, intersect_y)
        end
      elsif self.y_intercept.nil?
        if _line.y_intercept.nil?
          raise ArgumentError, "Intersection cannot be found -- lines are parallel"
        elsif _line.x_intercept.nil?
          return Point.new(self.x_intercept.x, _line.y_intercept.y)
        else
          intersect_y = _line.slope * self.x_intercept.x + _line.y_intercept.y
          return Point.new(self.x_intercept.x, intersect_y)
        end
      elsif self.x_intercept.nil?
        if _line.x_intercept.nil?
          raise ArgumentError, "Intersection cannot be found -- lines are parallel"
        elsif _line.y_intercept.nil?
          return Point.new(_line.x_intercept.x, self.y_intercept.y) 
        else
          intersect_x = (self.y_intercept.y - _line.y_intercept.y) / _line.slope
          return Point.new(intersect_x, self.y_intercept.y)
        end
      end
      #calculate intersections using mx - y = -b
      determinant = (self.slope * -1) - (_line.slope * -1)
      determinant_x = (self.y_intercept.y) - (_line.y_intercept.y)
      determinant_y = (self.slope * _line.y_intercept.y * -1) - (_line.slope * self.y_intercept.y * -1)
      intersect_x = determinant_x/determinant
      intersect_y = determinant_y/determinant
      Point.new(intersect_x, intersect_y)
    end

    def ==(_line)
      (self.x_intercept == _line.x_intercept) && (self.y_intercept == _line.y_intercept)
    end

    def self._calculate_slope(_point_a, _point_b)
      difference = _point_a - _point_b
      if difference.x == 0.0
        return nil
      elsif difference.y == 0.0
        return 0.0
      else 
        difference.y / difference.x
      end
    end

    def self._calculate_y_intercept(_slope, _point)
      return nil if _slope.nil? 
      y_intercept = _point.y - (_slope * _point.x)
      Point.new(0, y_intercept)
    end

    def self._calculate_x_intercept(_slope, _point)
      if _slope.nil?
        return Point.new(_point.x, 0)
      elsif _slope == 0
        return nil
      end
      x_intercept = ((-1 * _point.y) / _slope) + _point.x
      Point.new(x_intercept, 0)
    end

    def _set_slope(_slope)
      if _slope.nil?
        @_slope = nil
      else
        @_slope = (Float _slope).round(10)
      end
    end

    def x_intercept=(_x_intercept)
      if _x_intercept.nil?
        @x_intercept = nil
      elsif
        x_intercept_rounded = Point.new((Float _x_intercept.x).round(10), 0)
        @x_intercept = x_intercept_rounded
      end
    end

    def y_intercept=(_y_intercept)
      if _y_intercept.nil?
        @y_intercept = nil
      elsif
        y_intercept_rounded = Point.new(0, (Float _y_intercept.y).round(10))
        @y_intercept = y_intercept_rounded
      end
    end


    def slope
      @_slope
    end

    private :_set_slope
    private_class_method :_calculate_slope, :_calculate_y_intercept, :_calculate_x_intercept
  end
end
