class Photo::CreatePaletteFromPhoto
  def self.call(path, resize: false, palette_image: false, test_mode: false)
    colour_data_hires = Photo::GetHistogramData.call(path, colours: 48, resize: resize)   
    colour_data_lores = Photo::GetHistogramData.call(path, colours: 4, resize: resize)


    ####### Current strategy:  ###################################################################
    ####### Get the 4 most prominent colours, and combine them with any important outliers #######

    commons  = Photo::ExtractMostCommonColours.call(colour_data_lores)
    outliers = Photo::ExtractOutliers.call(colour_data_hires)

    results  = Photo::CompileToDominant.call(commons, outliers)

    binding.pry if test_mode

    Photo::CreatePaletteImage.call(results, path) if palette_image

    results
  end
end
