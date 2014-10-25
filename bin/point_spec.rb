require 'Graph'
include Graph

RSpec.describe Point do

  before(:each) do 
    @point = Point.new(0, 0)
  end

  describe '#-' do
    it "(0, 0) - (6, 7)" do
      point = Point.new(6,7)
      actual = @point - point
      expected = Point.new(-6, -7)
      expect(actual).to eq(expected)
    end
  end

  describe '#+' do
    it "(0, 0) + (-3, 4)" do
      point = Point.new(-3, 4)
      actual = @point + point
      expected = Point.new(-3, 4)
      expect(actual).to eq(expected)
    end
  end

  describe '#distance_to_point' do
    it "distance from (0, 0) to (100, 17)" do
      point = Point.new(100, 17)
      actual = @point.distance_to_point(point)
      expected = Math.sqrt(10289)
      expect(actual).to eq(expected)
    end
  end

end

RSpec.describe Line do

  describe '::calculate_with_points' do
    context 'given (10, 4) and (3, 4)' do
      before(:each) do
        point_a = Point.new(10, 4)
        point_b = Point.new(3, 4)
        @actual = Line.calculate_with_points(point_a, point_b)
      end 
      it 'calculates line y = 4 (using ::calculate_with_intercepts)' do
        expected = Line.calculate_with_intercepts(nil, Point.new(0, 4))
        expect(@actual).to eq(expected)
      end

      it 'calculates line y = 4 (using ::calculate_with_slope_and_point)' do
        expected = Line.calculate_with_slope_and_point(0, Point.new(0, 4))
        expect(@actual).to eq(expected)
      end
    end

    context 'given (3, 10) and (3, 0)' do
      before(:each) do
        point_a = Point.new(3, 10)
        point_b = Point.new(3, 0)
        @actual = Line.calculate_with_points(point_a, point_b)
      end
      it 'calculates line x = 3 (using ::calculate_with_intercepts)' do
        expected = Line.calculate_with_intercepts(Point.new(3, 0), nil)
        expect(@actual).to eq(expected)
      end

      it 'calculates line x = 3 (using ::calculate_with_slope_and_point)' do
        expected = Line.calculate_with_slope_and_point(nil, Point.new(3, 0))
        expect(@actual).to eq(expected)
      end
    end

    context 'given (3, 32) and (4, 50)' do
      it 'calculates the same line independent of parameter order' do
        point_a = Point.new(3, 32)
        point_b = Point.new(4, 50)
        actual = Line.calculate_with_points(point_a, point_b)
        expected = Line.calculate_with_points(point_b, point_a)
        expect(actual).to eq(expected)
      end
    end

    context 'given (32, 20) and (300, 26)' do 
      before(:each) do 
        point_a = Point.new(32, 20)
        point_b = Point.new(300, 26)
        @actual = Line.calculate_with_points(point_a, point_b)
      end
      it 'calculates line y = 3/134x + 1292/67 (using ::calculate_with_intercepts)' do
        expected_intercept_x = Point.new((-1292.0/67) * (134.0/3), 0)
        expected_intercept_y = Point.new(0, 1292.0/67)
        expected = Line.calculate_with_intercepts(expected_intercept_x, expected_intercept_y)
        expect(@actual).to eq(expected)
      end

      it 'calculates y = 3/134x + 1292/67 (using ::calculate_with_slope_and_point)' do
        expected = Line.calculate_with_slope_and_point(3.0/134, Point.new(0, 1292.0/67))
        expect(@actual).to eq(expected)
      end
    end


    context 'given points (24, 50) and (24, 50)' do
      it 'raises ArgumentError' do
        point_a = Point.new(24, 50)
        point_b = Point.new(24, 50)
        expect { Line.new(point_a, point_b) }.to raise_error(ArgumentError)
      end
    end
  end 

  describe '#intersection' do
    context '2 horizontally parallel lines' do
      it 'raises ArgumentError' do
        line_a_point_a = Point.new(2, 50)
        line_a_point_b = Point.new(100, 50)
        line_b_point_a = Point.new(10, 400)
        line_b_point_b = Point.new(1000, 400)
        line_a = Line.calculate_with_points(line_a_point_a, line_a_point_b)
        line_b = Line.calculate_with_points(line_b_point_a, line_b_point_b)
        expect { line_a.intersection(line_b) }.to raise_error(ArgumentError)
      end
    end

    context '2 vertically parallel lines' do
      it 'raises ArgumentError' do
        line_a_point_a = Point.new(2, 50)
        line_a_point_b = Point.new(2, -36)
        line_b_point_a = Point.new(400, 39)
        line_b_point_b = Point.new(400, -1000)
        line_a = Line.calculate_with_points(line_a_point_a, line_a_point_b)
        line_b = Line.calculate_with_points(line_b_point_a, line_b_point_b)
        expect { line_a.intersection(line_b) }.to raise_error(ArgumentError)
      end
    end

    context 'given lines y = 4 and x = 30' do 
      before(:each) do 
        @line_a = Line.calculate_with_intercepts(Point.new(30, 0), nil)
        @line_b = Line.calculate_with_intercepts(nil, Point.new(0, 4))
        @expected = Point.new(30, 4)
      end

      it 'returns point (30, 4)' do
        actual = @line_a.intersection(@line_b)
        expect(actual).to eq(@expected)
      end

      it 'returns point (30, 4) (commutative)' do
        actual = @line_b.intersection(@line_a)
        expect(actual).to eq (@expected)
      end
    end

    context 'lines y = 4 and y = 15x + 32' do
      before(:each) do
        @line_a = Line.calculate_with_intercepts(nil, Point.new(0, 4))
        @line_b = Line.calculate_with_slope_and_point(15, Point.new(0, 32))
        @expected = Point.new(-28.0/15, 4)
      end

      it 'returns point (-28/15, 4)' do
        actual = @line_a.intersection(@line_b) 
        expect(actual).to eq(@expected)
      end

      it 'returns point(-28/15, 4) (commutative)' do
        actual = @line_b.intersection(@line_a) 
        expect(actual).to eq(@expected)
      end
    end

    context 'x = 78 and y = 15x + 32' do
      before(:each) do
        @line_a = Line.calculate_with_intercepts(Point.new(78, 0), nil)
        @line_b = Line.calculate_with_slope_and_point(15, Point.new(0, 32))
        @expected = Point.new(78, 1202)
      end

      it 'returns point (78, 1202)' do
        actual = @line_a.intersection(@line_b)
        expect(actual).to eq(@expected)
      end

      it 'returns point (78, 1202) (commutative)' do
        actual = @line_b.intersection(@line_a)
        expect(actual).to eq(@expected)
      end
    end

    context 'y = 5x - 20 and y = 12x+32' do
      it 'returns point (-52/7, -400/7)' do
        line_a = Line.calculate_with_slope_and_point(5, Point.new(0, -20))
        line_b = Line.calculate_with_slope_and_point(12, Point.new(0, 32))
        actual = line_a.intersection(line_b)
        expected = Point.new(-52.0/7, -400.0/7)
        expect(actual).to eq(expected) 
      end
    end
  end

  describe '#distance_to_point' do
    context 'y = 35x + 100 and point (15, 30)' do
      it 'returns distance 595/sqrt(1226)' do
        line = Line.calculate_with_slope_and_point(35, Point.new(0, 100))
        point = Point.new(15, 30) 
        actual = line.distance_to_point(point)
        expected = 595/Math.sqrt(1226)
        expect(actual).to eq(expected)
      end
    end
    
    context 'y = 20x + 94 and point (16, 414)' do
      it 'returns distance 0' do
        line = Line.calculate_with_slope_and_point(20, Point.new(0, 94))
        point = Point.new(16, 414)
        actual = line.distance_to_point(point)
        expected = 0
        expect(actual).to eq(expected)
      end 
    end

    context 'y = 160 and point (10, 1000)' do
      it 'returns distance 840' do
        line = Line.calculate_with_intercepts(nil, Point.new(0, 160))
        point = Point.new(10, 1000)
        actual = line.distance_to_point(point)
        expected = 840
        expect(actual).to eq(expected)
      end
    end

    context 'x = 14 and point (10, 24)' do
      it 'returns distance 4' do
        line = Line.calculate_with_intercepts(Point.new(14, 0), nil)
        point = Point.new(10, 24)
        actual = line.distance_to_point(point)
        expected = 4
        expect(actual).to eq(expected)
      end
    end
  end
end

