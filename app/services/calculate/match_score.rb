class Calculate::MatchScore
  def self.call(data, p2)
    if data.is_a? Photo

      # Don't even bother with B&W photos if our photo isnt B&W
      return 0 if p2.stat.hsb['s']['mean'] < 10 && data.stat.hsb['s']['mean'] > 10

      if data.stat.hsb["h"]["deviation"] < 8
        if p2.stat.hsb["h"]["deviation"] < 8
          c1 = { l: data.stat.lab['l']['mean'], a: data.stat.lab['a']['mean'], b: data.stat.lab['b']['mean'] }
          c2 = { l: p2.stat.lab['l']['mean'], a: p2.stat.lab['a']['mean'], b: p2.stat.lab['b']['mean'] }        
          score = normalized_dist(c1, c2)   
        else
          score = 0
        end
      else
       
        score = 0


        # We take the most common colour, and the most saturated/bright colour, and just compare those for both p1 and p2
        score = by_saturation_and_common(data, p2)

        # We consider any non-grey colour that has a match score over 88% a 'match'.
        # We need at least half the colours to be matches for it to be returned, and we return the average match.
        # score = by_threshold_num_of_matches(data, p2)


        # We find the highest p2 match for each of our p1 colours regardless of anything, and return the average match score.
        # score = by_average_match(data, p2)
        



      end
    else
      # Let's compare our colour to all the colours in the photo, and find the closest one.
      c1 = data[:lab]
      c2 = get_nearest_colour(c1, p2.photo_colours)
      score = normalized_dist(c1, c2)   
    end

    score
  end

  private

  def self.by_average_match(p1, p2)
    scores = []
    p1.photo_colours.each do |c1|
      best_match = 0
      p2.photo_colours.each do |c2|
        current_match = normalized_dist(c1, c2)

        best_match = current_match if current_match > best_match
      end

      scores << best_match
    end

    Maths.mean(scores).round(2)
  end

  def self.by_threshold_num_of_matches(p1, p2)
    matching_colours = []

    # We only want to compare colours that aren't greyscale, or near it.
    good_p1_colours = p1.photo_colours.select { |c| c.hsb["s"] > 18 }
    good_p2_colours = p2.photo_colours.select { |c| c.hsb["s"] > 18 }

    if good_p2_colours.any?
      good_p1_colours.each do |c|
        closest = get_nearest_colour(c, good_p2_colours)
        dist    = normalized_dist(c, closest)

        if dist >= 88
          matching_colours << dist
        end
      end
    end

    # We consider it a match if at least half of the colours match
    if matching_colours.count >= (good_p1_colours.count * 0.5).ceil
      score = Maths.mean(matching_colours).round(2)
    end  
  end

  def self.by_saturation_and_common(p1, p2)
    common_p1     = get_most_common(p1.photo_colours)
    common_p2     = get_most_common(p2.photo_colours)
    score_part_1  = normalized_dist(common_p1, common_p2)

    saturated_p1  = get_most_saturated(p1.photo_colours)
    saturated_p2  = get_most_saturated(p2.photo_colours)
    score_part_2  = normalized_dist(saturated_p1, saturated_p2)

    ((score_part_1 + score_part_2) / 2).round(2)
  end

  def self.get_most_common(colours)
    colours.sort { |a, b|  b.coverage <=> a.coverage }.first
  end

  def self.get_most_saturated(colours)
    colours.sort { |a, b|  (b.hsb['s'] + b.hsb['b'] * 0.75) <=> (a.hsb['s'] + a.hsb['b'] * 0.75) }.first
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