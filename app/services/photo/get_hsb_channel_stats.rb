class Photo::GetHSBChannelStats
  def self.call(colour_data)
    {
      h: get_channel_stats(colour_data, :h),
      s: get_channel_stats(colour_data, :s),
      b: get_channel_stats(colour_data, :b)
    }
  end

  private

  def self.get_channel_stats(all_colours, channel)
    colours   = all_colours.map { |c| [c[:hsb][channel]] * (c[:occurances] / 500.0).ceil}.flatten
    mean      = Maths.mean(colours)
    deviation = Maths.standard_deviation(colours)
    outliers  = get_outliers(all_colours, colours, channel, mean, deviation)

    return {
      colours:   colours,
      mean:      mean,
      deviation: deviation,
      outliers:  outliers
    }

  end

  def self.get_outliers(all_colours, measuring_colours, channel, mean, deviation, threshold=3)
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