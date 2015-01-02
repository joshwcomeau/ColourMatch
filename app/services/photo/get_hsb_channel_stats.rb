# REPURPOSED.
# Refactor me so I only do 1 job: returning mean/deviation for HSB channels.

class Photo::GetHSBChannelStats
  
  def self.call(colour_data)
    [
      get_channel_stats(colour_data, :h),
      get_channel_stats(colour_data, :s),
      get_channel_stats(colour_data, :b)
    ]
  end

  private

  def self.get_channel_stats(colour_data, channel)
    colours   = build_representative_array(colour_data, channel)
    mean      = Maths.mean(colours)
    deviation = Maths.standard_deviation(colours)

    return {
      channel:   channel,
      mean:      mean,
      deviation: deviation,
    }

  end

  # I want to take into account how many times a colour is repeated, when getting deviation.
  # However, it adds too much to the processing time to use every pixel, so I'm dividing 
  # occurances by 500 so get a general representation of the occurances, without killing CPU.
  def self.build_representative_array(colours, channel)
    colours.map { |c| [c[:hsb][channel]] * (c[:occurances] / 500.0).ceil}.flatten
  end

end