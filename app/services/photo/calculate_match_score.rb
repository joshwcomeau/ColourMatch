class Photo::CalculateMatchScore
  # TWO IDEAS:

  # 1) Given P1 and P2 with colours P1C1-P1C6 and P2C1-P2C6, iterate through P1 colours.
  # Find the closest P2 colour and pair them as a match.
  # eg. [1c1, 2c4], [1c2, 2c1], [1c3, 2c3], [1c4, 2c1], [1c5, 2c3].

  # Pay attention to the occurances. We care about not only how close the two colours are, but
  # how similar their occurance is. two matched colours that each take up 40% are more important
  # than two matched colours where one takes up 70% and the other takes up 10%.

  # 2) Just look at the means and standard deviation for HSB. If two photos have similar values
  # for those 6 stats, it's very likely that they're a good match!

  # I think #2 would work better for photos that have low standard deviations. THe higher the SD,
  # the less likely the colors are to line up. So maybe we should check the SD, and decide which method
  # to use based on that?
  
  def self.call(p1, p2)

    mean_dist = get_distance(p1.hue_mean, p2.hue_mean, hue: true)
    # At this point, the perfect match is a 0, and the worst match is 380 (hue is 180 to be on opposite ends)
    # Let's say a good match is anything below 60. 
    mean_dist + p2.hue_deviation

    # We might need to tweak this formula, since brightness doesn't seem as important, and 
    # we're not taking standard deviation into account at all

  end

  private

  def self.get_distance(h1, h2, hue: false)
    # Hue is tricky because 5 is very close to 360. It's circular.
    # If the distance between them is more than half of the total (360 degrees), we add 360 to the lower value.
    if hue && get_distance(h1, h2) > 180
      h1 < h2 ? h1 += 360 : h2 += 360
    end
    
    (h1 - h2).abs
  end

end