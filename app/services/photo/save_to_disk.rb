class Photo::SaveToDisk
  def self.call(photo, sanitized_name)
    return false unless photo.content_type =~ /image/
    directory = "public/upload"
    path = File.join(directory, sanitized_name)
    if File.open(path, "wb") { |f| f.write(photo.read) }
      return path.to_s
    else
      return false
    end
  end

end
