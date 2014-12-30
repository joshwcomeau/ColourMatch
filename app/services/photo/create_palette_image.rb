class Photo::CreatePaletteImage
  def self.call(colours, path)
    filename = extract_filename(path)
    imagemagick_cmd = build_system_string(colours, filename)
    system imagemagick_cmd
  end

  private

  def self.extract_filename(path)
    path.split("/").last.split(".").first
  end

  def self.build_system_string(colours, filename)
    str = "convert -size 100x100 "
    colours.each do |c|
      c[:colour][:rgb].symbolize_keys!
      str += "xc:'srgb(#{c[:colour][:rgb][:r]},#{c[:colour][:rgb][:g]},#{c[:colour][:rgb][:b]})' "
    end
    str += "+append 'public/upload/#{filename}_palette.png'"
  end
end