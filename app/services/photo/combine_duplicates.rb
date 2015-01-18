class Photo::CombineDuplicates
  def self.call(colour_data)
    # create a copy of the array to avoid fiddling with the one we're iterating over
    distinct_colours = colour_data

    colour_data.combination(2) do |a, b|
      if a[:closest].id == b[:closest].id
        to_live_on, to_be_killed = sort_by_sat(a, b)
        live_index, die_index = distinct_colours.find_index(to_live_on), distinct_colours.find_index(to_be_killed)

        # Now, it's possible that we've already nullified one of these values.
        # If so, we don't need to do anything.
        unless live_index.nil? || die_index.nil?
          distinct_colours[live_index][:occurances] += distinct_colours[die_index][:occurances]
          distinct_colours[live_index][:coverage] += distinct_colours[die_index][:coverage]
          distinct_colours[die_index] = nil
        end
      end
    end

    distinct_colours.compact
  end

  private
  
  def self.sort_by_sat(*args)
    args.sort do |a, b| 
      b[:colour][:hsb]['s'] <=> a[:colour][:hsb]['s']
    end
  end  
end