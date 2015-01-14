class Calculate::MatchScore
  def self.call(mode, data, p2)
    score = nil

    if mode == 'photo'
      p1 = data
      # We're going to make a colour out of the mean LAB coordinates for both photos, and get the 
      # distance between them. 
      c1    = { l: p1.stat.lab['l']['mean'], a: p1.stat.lab['a']['mean'], b: p1.stat.lab['b']['mean'] }
      c2    = { l: p2.stat.lab['l']['mean'], a: p2.stat.lab['a']['mean'], b: p2.stat.lab['b']['mean'] }
      dist  = Calculate::Distance.call(c1, c2)
      score = Calculate::NormalizedDistance.call(dist)

    elsif mode == 'colour'
      judged_colours = p2.photo_colours.where(outlier: false)
      score = judged_colours.inject(0) do |result, elem|
        result  += Calculate::Distance.call(data, elem, mode: :hsb) * (elem.coverage * 0.01) 
        result
      end

      # At this point, we have a number between 0 and 256. We want to normalize that.
      score = Calculate::NormalizedDistance.call(score)

      # Option 2: means and deviations

    end
 
    score.round(2)

  end

end