class Photo::ExtractOutliers
  THRESHOLD = 1.5 # Minimum z-score to be considered an outlier.

  def self.call(colour_data, colour_stats)
    # We don't want colours that take up less than 0.1% of the canvas.
    # Filter those out first, to save on processing later.
    
    outliers  = get_all_outliers(colour_data, colour_stats)

    if outliers.any?
      outliers  = sort_by_zscore(outliers) 

      # I want the saturation bin to hold the most saturated utlier
      outliers  = bring_saturation_to_front(outliers).first(5)

      # I only want 1 outlier per Bin
      # outliers  = limit_outliers_by_bins(outliers).first(5)

      # I only want 1 outlier per type
      outliers  = limit_outliers_by_type(outliers)

      Photo::BuildColourArray.call(outliers, colour_data, colour_type: 'outlier')
    else
      []
    end
  end

  
  private

  def self.get_all_outliers(colour_data, colour_stats)
    outliers = colour_data[:colours].map do |c|
      highest = find_highest_zscore(c, colour_stats)
      highest[:z_score].abs >= THRESHOLD ? c.merge(highest) : nil
    end

    outliers.compact.uniq
  end

  def self.find_highest_zscore(c, colour_stats)
    winner = { outlier_channel: nil, z_score: 0 }


    colour_stats[:hsb].each do |channel, stat|
      if channel != :h || Colour::ValidHue.call(c)
        colour_val  = c[:hsb][channel] 
        z_score     = Maths.z_score(colour_val, mean: stat[:mean], deviation: stat[:deviation])

        if z_score.abs > winner[:z_score] 
          winner = { outlier_channel: channel, z_score: z_score } 
        end
      end
    end

    winner
  end

  def self.sort_by_zscore(colours)
    colours.sort { |a, b| b[:z_score].abs <=> a[:z_score].abs }
  end

  def self.bring_saturation_to_front(colours)
    colours.unshift(colours.delete(colours.sort { |a, b| b[:hsb][:s] <=> a[:hsb][:s] }.first))
  end

  def self.sort_by_sat(colours)
    colours.sort { |a, b| b[:hsb][:s] <=> a[:hsb][:s] }
  end

  def self.limit_outliers_by_bins(outliers)
    bins = Bin.all
    bins_taken = []

    outliers.select do |o|
      bin = Bin::FindClosest.call(o[:lab])
      if bins_taken.include? bin
        false
      else
        bins_taken << bin
        true
      end
    end
  end

  def self.limit_outliers_by_type(outliers)
    outliers.uniq { |o| o[:outlier_channel]}
  end
end