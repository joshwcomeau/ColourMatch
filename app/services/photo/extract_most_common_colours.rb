class Photo::ExtractMostCommonColours
  def self.call(colour_data)
    matched_colours   = Photo::BuildColourArray.call(colour_data[:colours], colour_data)
    distinct_colours  = Photo::CombineDuplicates.call(matched_colours)
    sorted_colours    = sort_by_occurances(distinct_colours)

    sorted_colours
  end

  private

  def self.sort_by_occurances(colours)
    colours.sort { |a, b| b[:occurances] <=> a[:occurances] }
  end

  

end