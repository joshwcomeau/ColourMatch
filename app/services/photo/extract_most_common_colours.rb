class Photo::ExtractMostCommonColours
  def self.call(colour_data)
    # Any colors that are < 0.8 from each other (using Colour::CalculateDistance) are too similar.
    # Remove the one with the least sat/brightness.
    matched_colours   = Photo::BuildColourArray.call(colour_data[:colours], colour_data)
    distinct_colours  = combine_duplicates(matched_colours)
    sorted_colours    = sort_by_occurances(distinct_colours)

    sorted_colours
  end

  private

  def self.sort_by_occurances(colours)
    colours.sort { |a, b| b[:occurances] <=> a[:occurances] }
  end

  def self.combine_duplicates(colours)
    # The goal here is to 'merge' duplicate colours.
    # We'll take the one that has a higher brightness+saturation,
    # and we'll sum their occurances so their totals both count for one.
    distinct_colours = colours

    colours.combination(2) do |a, b|
      if a[:colour][:id] == b[:colour][:id]
        a_index, b_index = distinct_colours.find_index(a), distinct_colours.find_index(b)
        distinct_colours[a_index][:occurances] += distinct_colours[b_index][:occurances]
        distinct_colours[b_index] = nil
      end
    end

    distinct_colours.compact
  end
  
  def self.sort_by_sat(*args)
    args.sort do |a, b| 
      b[:colour][:hsb]['s'] <=> a[:colour][:hsb]['s']
    end
  end  
end