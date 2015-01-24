class Calculate::MatchScore
  def self.call(data, p2)
    if data.is_a? Photo

      if data.stat.hsb["h"]["deviation"] < 20 && p2.stat.hsb["h"]["deviation"] < 60
        c1 = { l: data.stat.lab['l']['mean'], a: data.stat.lab['a']['mean'], b: data.stat.lab['b']['mean'] }
        c2 = { l: p2.stat.lab['l']['mean'], a: p2.stat.lab['a']['mean'], b: p2.stat.lab['b']['mean'] }        
        score = normalized_dist(c1, c2)   
      else
        matching_colours = []
        score = 0


        # What if we just grab photos where the most saturated colours line up, and the mean brightness is about the same?
        common_data   = get_most_common(data.photo_colours)
        common_target = get_most_common(p2.photo_colours)
        score_part_1 = normalized_dist(common_data, common_target)

        
        saturated_data   = get_most_saturated(data.photo_colours)
        saturated_target = get_most_saturated(p2.photo_colours)

        score_part_2 = normalized_dist(saturated_data, saturated_target)


        score = ((score_part_1 + score_part_2) / 2).round(2)
        
        # We only want to compare colours that aren't greyscale, or near it.
        # good_data_colours   = data.photo_colours.select { |c| c.hsb["s"] > 18 }
        # good_target_colours = p2.photo_colours.select   { |c| c.hsb["s"] > 18 }


        # if good_target_colours.any?
        #   good_data_colours.each do |c|
        #     closest = get_nearest_colour(c, good_target_colours)
        #     dist = normalized_dist(c, closest)
        #     if dist >= 88
        #       matching_colours << dist
        #     end
        #   end
        # end

        # # We consider it a match if at least half of the colours match
        # if matching_colours.count >= (good_data_colours.count * 0.5).ceil

        #   score = Maths.mean(matching_colours).round(2)
        # end


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

  def self.get_most_common(colours)
    colours.sort { |a, b|  b.coverage <=> a.coverage }.first
  end

  def self.get_most_saturated(colours)
    colours.sort { |a, b|  b.hsb['s'] <=> a.hsb['s'] }.first
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