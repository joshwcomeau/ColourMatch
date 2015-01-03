class Photo::CreatePaletteFromPhoto
  HIRES = 48
  LORES = 4
  def self.call(path, resize: false, palette_image: false, test_mode: false)
    colour_data_hires = Photo::GetHistogramData.call(path, colours: HIRES, resize: resize)   
    colour_data_lores = Photo::GetHistogramData.call(path, colours: LORES, resize: resize)


    ####### Current strategy:  ###################################################################
    ####### Get the 4 most prominent colours, and combine them with any important outliers #######

    commons  = Photo::ExtractMostCommonColours.call(colour_data_lores)

    colour_data_hires[:colours] = Photo::FilterColoursByOccurance.call(colour_data_hires) 
    hsb_colour_stats = Photo::GetHSBChannelStats.call(colour_data_hires[:colours])

    outliers = Photo::ExtractOutliers.call(colour_data_hires, hsb_colour_stats)

    results  = {
      colours: Photo::CompileToDominant.call(commons, outliers),
      stats:   hsb_colour_stats
    }

    binding.pry if test_mode

    Photo::CreatePaletteImage.call(results[:colours], path) if palette_image

    results
  end
end
