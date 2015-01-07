module FindFurthestColours
  def compare_all_in_db
    max_dist = 0
    colours  = Colour.all
    
    colours.each do |c1|
      colours.each do |c2|
        dist = Colour::CalculateDistance.call(c1, c2)
        if dist > max_dist
          max_dist    = dist 
          max_colours = [c1, c2]
        end
      end
    end

    {
      dist:    max_dist,
      colours: [c1.id, c2.id]
    }
  end
end