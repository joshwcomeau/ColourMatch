class Photo::CreatePaletteFromPhoto
  def self.call(path, resize: false, palette_image: false, test_mode: false)
    # Let's get 6-bit (64-colour) data
    colour_data_6_bit      = Photo::GetHistogramData.call(path, colours: 64, resize: resize)
    hsb_channel_data_6_bit = Photo::GetHSBChannelStats.call(colour_data_6_bit)
    
    # Let's get 3-bit (16-colour) data
    colour_data_3_bit      = Photo::GetHistogramData.call(path, colours: 8, resize: resize)
    # hsb_channel_data_4_bit = Photo::GetHSBChannelStats.call(colour_data_3_bit)


    ####### Current strategy:  #########################################################
    ####### Combine the 4-6 most popular 16-bit colors, as well as 0-2 outliers ########

    commons  = Photo::ExtractMostCommonColours.call(colour_data_3_bit)
    outliers = Photo::ExtractOutliers.call(hsb_channel_data_6_bit)

    results  = Photo::CompileToDominant.call(commons, outliers)

    binding.pry if test_mode

    Photo::CreatePaletteImage.call(results, path) if palette_image

    results
  end
end
