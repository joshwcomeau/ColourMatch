# REPURPOSED.
# Refactor me so I only do 1 job: returning mean/deviation for HSB channels.

class Photo::GetHSBChannelStats
  
  def self.call(colours)
    [
      get_channel_stats(colours, :h),
      get_channel_stats(colours, :s),
      get_channel_stats(colours, :b)
    ]
  end

  private

  def self.get_channel_stats(all_colours, channel)

    colours   = build_representative_array(all_colours, channel)
    mean      = Maths.mean(colours)
    deviation = Maths.standard_deviation(colours)
    # outliers  = get_outliers(all_colours, colours, channel, mean, deviation)

    return {
      channel:   channel,
      mean:      mean,
      deviation: deviation,
    }

  end

  # I want to take into account how many times a colour is repeated, when getting deviation.
  # However, it adds too much to the processing time to use every pixel, so I'm dividing 
  # occurances by 500 so get a general representation of the occurances, without killing CPU.
  def self.build_representative_array(all_colours, channel)
    all_colours.map { |c| [c[:hsb][channel]] * (c[:occurances] / 500.0).ceil}.flatten
  end

  # No longer used. Moved to Photo::ExtractOutliers
  def self.get_outliers(all_colours, measuring_colours, channel, mean, deviation, threshold=1)
    outliers = []
    all_colours.each do |c| 

      z_score = Maths.z_score(c[:hsb][channel], measuring_colours, mean, deviation).abs
      if z_score > threshold

        # For saturation and brightness, we only want colors ABOVE the mean (positive z-score)
        if channel == :h || c[:hsb][channel] > mean
          c[:z_score] = z_score
          outliers.push(c)
        end
      end
    end
    outliers
  end

end