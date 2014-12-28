class Photo::CreatePaletteFromPhoto
  def self.call(path, resize=false)
    # Let's get 6-bit (64-colour) data
    colour_data_6_bit      = Photo::GetHistogramData.call(path, 64)
    hsb_channel_data_6_bit = Photo::GetHSBChannelStats.call(colour_data_6_bit)
    
    # Let's get 4-bit (16-colour) data
    colour_data_4_bit      = Photo::GetHistogramData.call(path, 16)
    # hsb_channel_data_4_bit = Photo::GetHSBChannelStats.call(colour_data_4_bit)


    ####### Current strategy:  #########################################################
    ####### Combine the 4-6 most popular 16-bit colors, as well as 0-2 outliers ########

    commons  = Photo::ExtractMostCommonColours.call(colour_data_4_bit)
    outliers = Photo::ExtractOutliers.call(hsb_channel_data_6_bit)

    Photo::CompileToDominant.call(commons, outliers)
  end
end
