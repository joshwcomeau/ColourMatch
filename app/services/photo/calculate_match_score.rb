class Photo::CalculateMatchScore
  def self.call(p1, p2)
    # Current strategy: Given P1 and P2 with colours P1C1-P1C6 and P2C1-P2C6, iterate through P1 colours.
    # Find the closest P2 colour and pair them as a match.
    # eg. [1c1, 2c4], [1c2, 2c1], [1c3, 2c3], [1c4, 2c1], [1c5, 2c3].

    # Pay attention to the occurances. We care about not only how close the two colours are, but
    # how similar their occurance is. two matched colours that each take up 40% are more important
    # than two matched colours where one takes up 70% and the other takes up 10%.

    # We could also look at hue mean/standard deviation. If two colours share the same mean/standard deviation,
    # it's pretty likely that they're a good match, right?
  end

end