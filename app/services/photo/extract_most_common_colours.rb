class Photo::ExtractMostCommonColours
  def self.call(colour_data)
    # Any colors that are < 0.8 from each other (using Colour::CalculateDistance) are too similar.
    # Remove the one with the least sat/brightness.
    matched_colours   = Photo::BuildColourArray.call(colour_data[:colours], colour_data)
    distinct_colours  = remove_very_similar(matched_colours)
    sorted_colours    = sort_by_occurances(distinct_colours)

    sorted_colours
  end

  private

  def self.sort_by_occurances(colours)
    colours.sort { |a, b| b[:occurances] <=> a[:occurances] }
  end

  def self.remove_very_similar(colours)
    # The goal here is to 'merge' very similar colours.
    # We'll take the one that has a higher brightness+saturation,
    # and we'll sum their occurances so their totals both count for one.
    distinct_colours = colours

    colours.combination(2) do |a, b|
      if Colour::CalculateDistance.call(a[:colour], b[:colour]) < 10
        a_index, b_index = distinct_colours.find_index(a), distinct_colours.find_index(b)

        if a_index && b_index # ensure we haven't already removed this item
          desc = sort_by_sat(a, b)

          distinct_colours[a_index][:occurances] += distinct_colours[b_index][:occurances]
          distinct_colours.delete(b)
        end
      end
    end

    distinct_colours
  end
end