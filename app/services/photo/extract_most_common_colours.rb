class Photo::ExtractMostCommonColours
  def self.call(colour_data)
    # matched_colours = match_colours_to_db(colour_data)

    # Any colors that are < 0.8 from each other (using Colour::CalculateDistance) are too similar.
    # Remove the one with the least sat/brightness.
    matched_colours = match_colours_to_db(colour_data.first(10))

    matched_colours = remove_duplicates(matched_colours)

    distinct_colours = remove_very_similar(matched_colours)

    sort_by_occurances(distinct_colours).first(6)

  end

  private

  def self.remove_duplicates(colours)
    Hash[ *colours.map{ |o| [ o[:colour], o ] }.flatten ].values
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

  def self.sort_by_occurances(colours)
    colours.sort { |a, b| b[:occurances] <=> a[:occurances] }
  end

  def self.sort_by_sat_bri(*args)
    args.sort do |a, b| 
      (b[:colour][:hsb]['s'] + b[:colour][:hsb]['b']) <=> (a[:colour][:hsb]['s'] + a[:colour][:hsb]['b'])
    end
  end

  def self.remove_very_similar(colours)
    # The goal here is to 'merge' very similar colours.
    # We'll take the one that has a higher brightness+saturation,
    # and we'll sum their occurances so their totals both count for one.
    distinct_colours = colours

    colours.combination(2) do |a, b|
      if Colour::CalculateDistance.call(a[:colour][:lab], b[:colour][:lab]) < 10
        a_index, b_index = distinct_colours.find_index(a), distinct_colours.find_index(b)

        if a_index && b_index # ensure we haven't already removed this item
          desc = sort_by_sat_bri(a, b)

          distinct_colours[a_index][:occurances] += distinct_colours[b_index][:occurances]
          distinct_colours.delete(b)
        end
      end
    end

    distinct_colours
  end

  def self.sat_bri(c)
    c[:colour][:hsb]['s'] + c[:colour][:hsb]['b']
  end
end