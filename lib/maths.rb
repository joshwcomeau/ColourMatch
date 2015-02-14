module Maths
  RAD_MULTIPLIER = 57.29577951580927
  DEG_MULTIPLIER = 0.0174532925

  def self.sum(a)
    a.inject(0, :+)
  end

  def self.mean(a)
    sum(a) / a.length.to_f
  end

  def self.sample_variance(a)
    m = mean(a)
    sum = a.inject(0) { |accum, i| accum + (i - m) ** 2 }
    sum / (a.size - 1).to_f
  end

  def self.standard_deviation(a)
    Math.sqrt(sample_variance(a))
  end

  def self.z_score(a, sample: nil, mean: nil, deviation: nil)
    raise "Need either the sample, or the mean and deviation, to calculate z-score" unless sample || (mean && deviation)
    # Calculate mean and deviation unless provided
    mean      ||= mean(sample)
    deviation ||= standard_deviation(sample)

    (a - mean) / deviation
  end

  def self.circular_mean(a, cartesian_array: nil)
    # a is an array of degree values from 0 to 360.
    # I need to convert it from degrees to cartesian coordinates [x, y].
    # cartesian_array ||= a.map(method(:convert_to_cartesian))

    # cartesian_array is a 2-dimensional array with x-y values.
    # eg. [ [1, 4], [2, 3], [1, 0.5] ]
    # Let's get the average x and y
    # average_x = mean( cartesian_array.map { |arr| arr[0] } )
    # average_y = mean( cartesian_array.map { |arr| arr[1] } )

    # let's convert this x,y pair back to polar coordinates, for our solution.
    # convert_to_polar(average_x, average_y)[:angle]

    # This two-line combo replaces all the above
    cartesian_array ||= a.map(method(:convert_to_cartesian))
    convert_to_polar(*cartesian_array.transpose.map(method(:mean)))[:angle]
  end

  def self.circular_deviation(a)
    cartesian_array = a.map(method(:convert_to_cartesian))

    # So this is tricky. We have two values for every point, [x, y].
    # Should I get the standard deviation of both x and y, and average them out?
    # dev_x = standard_deviation( cartesian_array.map { |arr| arr[0] } )
    # dev_y = standard_deviation( cartesian_array.map { |arr| arr[1] } )

    # convert_to_polar(dev_x, dev_y)[:angle]

    # This one-line combo replaces all the above
    convert_to_polar(*cartesian_array.transpose.map(method(:standard_deviation)))[:angle]
  end

  def self.convert_to_cartesian(angle, radius: 1, type: :radians)
    # If supplied with the angle in degrees, we need to convert to radians.
    angle *= DEG_MULTIPLIER

    # We're using the unit circle by default for all calculations; radius = 1
    [ radius * Math::cos(angle) , radius * Math::sin(angle) ]
  end


  def self.convert_to_polar(x, y)
    # we don't need the radius for calculating circular_mean, but what the hell.
    r = (x**2 + y**2)**0.5

    radians = Math::atan(y/x)
    angle   = radians * RAD_MULTIPLIER

    case find_quadrant(x, y)
    when 2 || 3
      angle += 180
    when 4
      angle += 360
    end

    {
      r:     r,
      angle: angle
    }
  end


  def self.find_quadrant(x, y)
    if x > 0
      quadrant = y > 0 ? 1 : 4
    else
      quadrant = y > 0 ? 2 : 3
    end

    return quadrant
  end
end