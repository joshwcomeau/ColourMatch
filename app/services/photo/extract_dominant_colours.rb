class Photo::ExtractDominantColours
  def self.call(colors16, colors64, total_to_extract=6)
    results  = []
    outliers = []
    
    all_outliers = get_all_outliers(colors64)
    results += get_highest_saturation_and_brightness(all_outliers, 2) if all_outliers.any?


    num_left_to_add = total_to_extract - results.length

    results += colors16.first(num_left_to_add).reverse


    results.reverse
  end

  private

  def self.get_all_outliers(colors)
    (colors[:h][:outliers] + colors[:s][:outliers] + colors[:b][:outliers]).uniq
  end

  def self.get_highest_saturation(outliers, num=1)
    outliers.sort_by { |o| o[:hsb][:s] }.last(num)
  end

  def self.get_highest_saturation_and_brightness(outliers, num=1)
    outliers.sort_by { |o| (o[:hsb][:s] + o[:hsb][:b]) }.last(num)
  end

  def self.consolidate_outliers(data)
    data[:h][:outliers] + data[:s][:outliers] + data[:b][:outliers]
  end
end