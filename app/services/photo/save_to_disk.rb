class Photo::SaveToDisk
  def self.call(photo)
    name = photo.original_filename
    directory = "public/upload"
    path = File.join(directory, name)
    if File.open(path, "wb") { |f| f.write(photo.read) }
      puts "File uploaded"
      return path.to_s
    else
      return false
    end
  end
end
