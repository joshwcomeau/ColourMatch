class Photo::BuildColourArray
  def self.call(colours, colour_data, colour_type: 'common')
    matched_colours = colours.map do |c|
      new_data = {
        type:       colour_type,
        colour:     Colour::FindClosest.call(c[:lab], false),
        occurances: c[:occurances],
        coverage:   (c[:occurances].to_f / colour_data[:pixels] * 100).round,
        original_colour: {
          rgb:  { r: c[:rgb][:r], g: c[:rgb][:g], b: c[:rgb][:b] },
          hex:  c[:hex]
        }
      }

      if colour_type == 'outlier'
        case c[:outlier_channel]
        when :h
          channel_name = "hue"
        when :s
          channel_name = "saturation"
        when :b
          channel_name = "brightness"
        end

        new_data[:outlier_channel]  = channel_name
        new_data[:z_score]          = c[:z_score]
      end

      new_data
    end

    unique_colours = matched_colours.uniq { |c| c[:colour][:id] }

  end
end