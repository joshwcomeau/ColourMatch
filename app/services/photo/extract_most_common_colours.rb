class Photo::ExtractMostCommonColours
  def self.call(colour_data)
    matched_colours = match_colours_to_db(colour_data)
    uniq_colours    = matched_colours.uniq

    # Any colors that are < 0.8 from each other (using Colour::CalculateDistance) are too similar.
    # Remove the one with the least sat/brightness.
    get_distinct_colours(uniq_colours).first(6)

  end

  private

  def self.match_colours_to_db(colour_data)
    colour_data.map do |c|
      Colour::FindClosest.call(c[:lab])
    end
  end

  def self.get_distinct_colours(colours)
    colours.select do |first_colour|
      distinct = true
      colours.each do |second_colour|
        if Colour::CalculateDistance.call(first_colour, second_colour) < 0.75 && first_colour != second_colour
          distinct = false if (first_colour[:hsb]['s'] + first_colour[:hsb]['b']) <= (second_colour[:hsb]['s'] + second_colour[:hsb]['b'])
        end
      end

      distinct
    end
  end
end