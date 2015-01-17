class Photo::GetChannelStats
  
  def self.call(colour_data)
    {
      hsb: {
        h: get_channel_stats(colour_data, space: :hsb, channel: :h),
        s: get_channel_stats(colour_data, space: :hsb, channel: :s),
        b: get_channel_stats(colour_data, space: :hsb, channel: :b)
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
    if channel == :h && colours.empty? # greyscale image
      mean, deviation = 0, 0
    else
      mean      = Maths.mean(colours)
      deviation = Maths.standard_deviation(colours)
    end

    return {
      mean:      mean,
      deviation: deviation,
    }

  end

  # I want to take into account how many times a colour is repeated, when getting deviation.
  # However, it adds too much to the processing time to use every pixel, so I'm dividing 
  # occurances by 500 so get a general representation of the occurances, without killing CPU.
  def self.build_representative_array(colours, space, channel)
    # White and black both have a hue of 0, which is in the reds.
    # A blue image with black, therefore, would have a purple mean. This is bad.
    # We want to ignore images whose brightness is either very very low or very very high.
    colours = remove_grey_and_dim_hues(colours) if channel == :h

    data = colours.map do |c| 
      [ c[space][channel] ] * ( c[:occurances] / 500.0 ).ceil
    end

    data.flatten
  end

  def self.remove_grey_and_dim_hues(colours)
    colours.select do |c| 
      Colour::ValidHue.call(c)
    end
  end

end