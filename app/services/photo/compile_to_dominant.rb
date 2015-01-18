class Photo::CompileToDominant
  def self.call(commons, outliers, palette_size=6, max_outliers=3)
    return commons.first(palette_size) if outliers.empty?

    outliers = remove_any_duplicates(commons, outliers)
    outliers = outliers.first(max_outliers)
    
    commons  = commons.first(palette_size - outliers.count)
    results  = []

    results + commons + outliers
  end

  private

  def self.remove_any_duplicates(commons, outliers)
    outliers.select do |o|
      unique = true
      commons.each do |c|
        unique = false if c[:closest] == o[:closest]
      end
      unique
    end
  end 
end