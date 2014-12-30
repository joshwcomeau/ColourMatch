class Photo::ExtractPrimaryColour
  def self.call(colour_data)
    match_colour_to_db(colour_data.first)
  end

  private


  def self.match_colour_to_db(c)
    { 
      type:       "primary",
      colour:     Colour::FindClosest.call(c[:lab]),
      occurances: c[:occurances]
    }
  end

end