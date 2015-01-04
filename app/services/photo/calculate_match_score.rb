class Photo::CalculateMatchScore
  def self.call(p1, p2)
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
    
  end

end