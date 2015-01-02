class Photo::BuildColourArray
  def self.call(colours, colour_data, colour_type: 'common')
    # The new format contains the colour from the DB, the type (common/outlier),
    # And both the occurances in px and the coverage in %.
    # Maybe even throw in some z-score data for outliers?
    matched_colours = colours.map do |c|
      new_data = {
        type:       colour_type,
        colour:     Colour::FindClosest.call(c[:lab], false),
        occurances: c[:occurances],
        coverage:   (c[:occurances].to_f / colour_data[:pixels] * 100).round,
        original_colour: {
          r: c[:rgb][:r],
          g: c[:rgb][:g],
          b: c[:rgb][:b],
        }
      }

      if colour_type == 'outlier'
        new_data[:outlier_channel]  = c[:outlier_channel]
        new_data[:z_score]          = c[:z_score]
      end

      new_data
    end
  end
end