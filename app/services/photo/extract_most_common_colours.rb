class Photo::ExtractMostCommonColours
  def self.call(colour_data)
    matched_colours = match_colours_to_db(colour_data)
    matched_colours.uniq.first(6)
  end

  private

  def self.match_colours_to_db(colour_data)
    colour_data.map do |c|
      Colour::FindClosest.call(c[:lab])
    end
  end
end