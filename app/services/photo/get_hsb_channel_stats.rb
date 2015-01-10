# Take each H value as an angle. call it A. cos( A ) = x, sin( A ) = y. 
# Average all x and y together. The average angle is going to be tan( y / x )

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
    colours.map! do |c| 
      # val = channel == :h ? convert_hue_to_angle(c[:hsb][:h]) : c[:hsb][channel]
      [ c[:hsb][channel] ] * ( c[:occurances] / 500.0 ).ceil
    end

    colours.flatten
  end

  # Currently not used. Still need to work out hue mean/sd.
  def self.convert_hue_to_angle(value)
    [ Math::cos(value), Math::sin(value) ]
  end

end