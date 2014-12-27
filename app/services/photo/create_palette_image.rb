class Photo::CreatePaletteImage
  def self.call(colours, filename)
    imagemagick_cmd = build_system_string(colours, filename)
    system imagemagick_cmd
  end

  private

  def self.build_system_string(colours, filename)
    str = "convert -size 100x100 "
    colours.each do |c|
      c[:colour][:rgb].symbolize_keys!
      str += "xc:'srgb(#{c[:colour][:rgb][:r]},#{c[:colour][:rgb][:g]},#{c[:colour][:rgb][:b]})' "
    end
    str += "+append 'public/upload/#{filename.split(".")[0]}_palette.png'"
  end
end