class Photo::BuildColourArray
  def self.call(colours, colour_data, colour_type: 'common')
    matched_colours = colours.map do |c|
      # We're moving into a new system where we keep the ACTUAL colour, and just use FindClosest to get the LABEL.
      # To break as little as possible, I want to keep the same structure, more-or-less, as before.
      closest = Colour::FindClosest.call(c[:lab], false)
      
      new_data = {
        type:       colour_type,
        colour:     {
          rgb:        { r: c[:rgb][:r], g: c[:rgb][:g], b: c[:rgb][:b] },
          hex:        c[:hex],
          hsb:        Colour::Convert.call(c[:rgb], :hsb),
          lab:        Colour::Convert.call(c[:rgb], :lab),
          label:      closest.label
        },
        closest:    closest,
        occurances: c[:occurances],
        coverage:   (c[:occurances].to_f / colour_data[:pixels] * 100).round,
      }

      if colour_type == 'outlier'
        case c[:outlier_channel]
        when :h
          channel_label = "Hue"
        when :s
          channel_label = "Saturation"
        when :b
          channel_label = "Brightness"
        end


        new_data[:outlier_channel]  = channel_label
        new_data[:z_score]          = c[:z_score].round(2)
      end

      new_data
    end

  end
end
