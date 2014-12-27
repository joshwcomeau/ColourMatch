class Photo::CompileToDominant
  def self.call(commons, outliers, palette_size=6, max_outliers=2)
    outliers = outliers.first(max_outliers)
    commons  = commons.first(palette_size - outliers.count)
    results  = []

    results + commons + outliers
  end
end