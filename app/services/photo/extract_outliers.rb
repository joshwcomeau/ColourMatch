class Photo::ExtractOutliers
  def self.call(colour_data)
    # We don't want colours that take up less than 0.1% of the canvas.
    # Filter those out first, to save on processing later.
    colour_data[:colours] = Photo::FilterColoursByOccurance.call(colour_data) 

    colour_stats = Photo::GetHSBChannelStats.call(colour_data[:colours])
    all_outliers = get_all_outliers(colour_data, colour_stats)







    # all_outliers = get_all_outliers(colour_data[:colours])

    # outliers = sort_by_zscore(all_outliers).first(5)

    # # We want the outlier that is most saturated/bright, as well.
    # highest_sat = sort_by_sat(all_outliers).first
    # outliers.unshift(highest_sat)



    # outliers = limit_outliers_by_bins(outliers)


    # match_colours_to_db(outliers).uniq { |c| c[:colour] }
  end

  
  private

  def self.get_all_outliers(colour_data, colour_stats)
    outliers = colour_data[:colours].map do |c|
      # Figure out if it's a hue, saturation, or brightness outlier.
      # if it is, return it along with other pertinent info 
      # (zscore, type of outlier, occurance, coverage percentage)

      # Unsure how best to do this.

      # Maybe iterate through our 3 colour_stats, looking for the highest z-score?
      # I should find a way to have different thresholds for different channels
      find_highest_zscore(c, colour_stats)

      hue_zscore = stuff
      sat_zscore = stuff
      brit_zscore = stuff

      max_zscore = [hue_zscore, sat_zscore, brit_zscore].max

      if max_channel > threshold
        c[:outlier_channel] = 

      if outlier
      end
    end

    outliers.compact.uniq

    (colours[:h][:outliers] + colours[:s][:outliers] + colours[:b][:outliers]).uniq
  end

  def self.find_highest_zscore(c, colour_stats)
    highest = 0
    colour_stats.each do |stat|
      z_score = Maths.z_score(c[:hsb][channel], mean: mean, deviation: deviation).abs
    end
  end

  def self.sort_by_zscore(colours)
    colours.sort { |a, b| b[:z_score] <=> a[:z_score] }
  end

  def self.sort_by_sat(colours)
    colours.sort { |a, b| b[:hsb][:s] <=> a[:hsb][:s] }
  end

  def self.limit_outliers_by_bins(outliers)
    # We only want max 1 outlier per bin.
    bins = Bin.all
    bins_taken = []

    outliers.select do |o|
      bin = Bin::FindClosest.call(o[:lab])
      bins_taken << bin unless bins_taken.include? bin
    end
  end

  # Pull me into my own service?
  def self.match_colours_to_db(colour_data)
    colour_data.map do |c|
      {
        type:       "outlier",
        colour:     Colour::FindClosest.call(c[:lab], false),
        occurances: c[:occurances]
      }
    end
  end

end