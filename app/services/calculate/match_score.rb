class Calculate::MatchScore
  def self.call(data, p2)
    better_way(data, p2)
  end

  private

  def self.better_way(data, p2)
    if data.is_a? Photo
      c1 = { l: data.stat.lab['l']['mean'], a: data.stat.lab['a']['mean'], b: data.stat.lab['b']['mean'] }
      c2 = { l: p2.stat.lab['l']['mean'], a: p2.stat.lab['a']['mean'], b: p2.stat.lab['b']['mean'] }
    else
      # Let's compare our colour to all the colours in the photo, and find the closest one.
      c1 = data[:lab]
      c2 = get_nearest_colour(c1, p2.photo_colours)
    end
    normalized_dist(c1, c2)   
  end

  def self.original_way(data, p2)
    if data.is_a? Photo
      c1 = { l: data.stat.lab['l']['mean'], a: data.stat.lab['a']['mean'], b: data.stat.lab['b']['mean'] }
    else
      c1 = data[:lab]
    end

    c2 = { l: p2.stat.lab['l']['mean'], a: p2.stat.lab['a']['mean'], b: p2.stat.lab['b']['mean'] }
    normalized_dist(c1, c2)
  end

  def self.normalized_dist(c1, c2)
    dist  = Calculate::Distance.call(c1, c2)
    Calculate::NormalizedDistance.call(dist).round(2)
  end

  def self.get_nearest_colour(c1, colours)
    closest_color = nil
    closest_distance = 1_000_000

    colours.each do |c2|
      distance = Calculate::Distance.call(c1, c2[:lab].symbolize_keys)

      if distance < closest_distance
        closest_distance = distance
        closest_color    = c2 
      end
    end

    closest_color
  end

end