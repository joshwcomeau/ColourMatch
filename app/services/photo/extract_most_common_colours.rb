class Photo::ExtractMostCommonColours
  def self.call(colour_data)
    # matched_colours = match_colours_to_db(colour_data)

    # Any colors that are < 0.8 from each other (using Colour::CalculateDistance) are too similar.
    # Remove the one with the least sat/brightness.
    matched_colours = match_colours_to_db(colour_data.first(10))

    matched_colours = remove_duplicates(matched_colours)

    distinct_colours = get_distinct_colours(matched_colours).first(6)
  end

  private

  def self.remove_duplicates(c)
    Hash[ *c.map{ |o| [ o[:colour], o ] }.flatten ].values
  end

  def self.match_colours_to_db(colour_data)
    colour_data.map do |c|
      { 
        type:       "common",
        colour:     Colour::FindClosest.call(c[:lab]),
        occurances: c[:occurances]
      }
    end
  end

  def self.get_distinct_colours(colours)
    colours.select do |first_colour|
      distinct = true
      colours.each do |second_colour|
        if Colour::CalculateDistance.call(first_colour[:colour][:lab], second_colour[:colour][:lab]) < 4 && first_colour != second_colour
          distinct = false if (first_colour[:colour][:hsb]['s'] + first_colour[:colour][:hsb]['b']) < (second_colour[:colour][:hsb]['s'] + second_colour[:colour][:hsb]['b'])
        end
      end

      distinct
    end
  end
end