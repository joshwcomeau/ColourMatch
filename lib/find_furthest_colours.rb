# A quick method of getting the greatest possible distance between two colours,
# using Calculate::Distance. Important since Calculate::MatchScore
# is normalizing data using this range. 

# It turns out the greatest distance, in LAB colourspace, is ~256, 
# the distance between pure blue #0000FF and pure green #00FF00.

module FindFurthestColours
  def compare_all_in_db
    max_dist    = 0
    max_colours = []
    colours     = Colour.all
    
    colours.each do |c1|
      colours.each do |c2|
        dist = Calculate::Distance.call(c1, c2)
        if dist > max_dist
          max_dist    = dist 
          max_colours = [c1, c2]
        end
      end
    end

    {
      dist:    max_dist,
      colours: max_colours
    }
  end
end