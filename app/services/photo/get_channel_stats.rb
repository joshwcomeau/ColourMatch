class Photo::GetChannelStats
  
  def self.call(colour_data)
    {
      hsb: {
        hue:        get_channel_stats(colour_data, space: :hsb, channel: :h),
        saturation: get_channel_stats(colour_data, space: :hsb, channel: :s),
        brightness: get_channel_stats(colour_data, space: :hsb, channel: :b)
      },
      lab: {
        l: get_channel_stats(colour_data, space: :lab, channel: :l),
        a: get_channel_stats(colour_data, space: :lab, channel: :a),
        b: get_channel_stats(colour_data, space: :lab, channel: :b)
      }
    }
  end

  private

  def self.get_channel_stats(colour_data, space:, channel:)
    colours   = build_representative_array(colour_data, space, channel)
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
  def self.build_representative_array(colours, space, channel)
    data = colours.map do |c| 
      [ c[space][channel] ] * ( c[:occurances] / 500.0 ).ceil
    end

    data.flatten
  end

end