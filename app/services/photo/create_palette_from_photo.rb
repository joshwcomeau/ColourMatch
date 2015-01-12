class Photo::CreatePaletteFromPhoto
  HIRES = 48
  LORES = 4
  def self.call(path, resize: false, palette_image: false)
    colour_data_hires = Photo::GetHistogramData.call(path, colours: HIRES, resize: resize)   
    colour_data_lores = Photo::GetHistogramData.call(path, colours: LORES, resize: resize)


    colour_data_hires[:colours] = Photo::FilterColoursByOccurance.call(colour_data_hires) 
    colour_stats                = Photo::GetChannelStats.call(colour_data_hires[:colours])

    commons  = Photo::ExtractMostCommonColours.call(colour_data_lores)
    outliers = Photo::ExtractOutliers.call(colour_data_hires, colour_stats)

    results  = {
      colours: Photo::CompileToDominant.call(commons, outliers),
      stats:   colour_stats
    }

    Photo::CreatePaletteImage.call(results[:colours], path) if palette_image

    results
  end
end
