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
    context 'given points (10, 4) and (3, 4)' do
      it 'calculates line y = 4' do
        point_a = Point.new(10, 4)
        point_b = Point.new(3, 4)
        actual = Line.calculate_with_points(point_a, point_b)
        expected = Line.calculate_with_intercepts(nil, Point.new(0, 4))
        expect(actual).to eq(expected)
      end
    end

    context 'given points (3, 10) and (3, 0)' do
      it 'calculates line x = 3' do
        point_a = Point.new(3, 10)
        point_b = Point.new(3, 0)
        actual = Line.calculate_with_points(point_a, point_b)
        expected = Line.calculate_with_intercepts(Point.new(3, 0), nil)
        expect(actual).to eq(expected)
      end
    end

    context 'given points (3, 32) and (4, 50)' do
      it 'calculates the same line independent of parameter order' do
        point_a = Point.new(3, 32)
        point_b = Point.new(4, 50)
        actual = Line.calculate_with_points(point_a, point_b)
        expected = Line.calculate_with_points(point_b, point_a)
        expect(actual).to eq(expected)
      end
    end

    context 'given points (32, 20) and (300, 26)' do 
      it 'calculates line y = 3/134x + 1292/67 (using ::calculate_with_intercepts)' do
        point_a = Point.new(32, 20)
        point_b = Point.new(300, 26)
        expected_intercept_x = Point.new((-1292.0/67) * (134.0/3), 0)
        expected_intercept_y = Point.new(0, 1292.0/67)
        actual = Line.calculate_with_points(point_a, point_b)
        expected = Line.calculate_with_intercepts(expected_intercept_x, expected_intercept_y)
        expect(actual).to eq(expected)
      end
    end

    context 'given points (32, 20) and (300, 26)' do 
      it 'calculates line y = 3/134x + 1292/67 (using ::calculate_with_slope_and_point)' do
        point_a = Point.new(32, 20)
        point_b = Point.new(300, 26)
        actual = Line.calculate_with_points(point_a, point_b)
        expected = Line.calculate_with_slope_and_point(3.0/134, point_a)
        expect(actual).to eq(expected)
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
        
      end
    end

    context '2 vertically parallel lines' do
      it 'raises ArgumentError' do
    end

    context 'given lines y = 4 and x = 30' do 
      it 'returns point (30, 4)' do

      end
    end

    context 'lines y = 4 and y = 15x + 32' do
      it 'returns point (-28/15, 4)' do

      end
    end

    context 'x = 78 and y = 15x + 32' do
      it 'returns point (78, 1202)' do
        
      end
    end

    context '2 slanted lines' do
      it 'calculates intersection' do
      
      end
    end
  end

end



