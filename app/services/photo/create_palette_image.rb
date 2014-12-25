class Photo::CreatePaletteImage
  def self.call(colours, filename)
    imagemagick_cmd = build_system_string(colours, filename)
    system imagemagick_cmd
  end

  private

  def self.build_system_string(colours, filename)
    str = "convert -size 100x100 "
    colours.each do |c|
      c[:rgb].symbolize_keys!
      str += "xc:'srgb(#{c[:rgb][:r]},#{c[:rgb][:g]},#{c[:rgb][:b]})' "
    end
    str += "+append 'public/upload/#{filename.split(".")[0]}_palette.png'"
  end
end