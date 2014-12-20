class Photo::SaveToDisk
  def self.call(photo, sanitized_name)
    directory = "public/upload"
    path = File.join(directory, sanitized_name)
    if File.open(path, "wb") { |f| f.write(photo.read) }
      puts "File uploaded"
      return path.to_s
    else
      return false
    end
  end

end
