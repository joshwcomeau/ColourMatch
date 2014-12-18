class Photo::ExtractDominantColours
  def self.call(colors16, colors64, total_to_extract=6)
    results  = []
    outliers = []
    
    # We want max 1 outlier per category.
    # With hue, we want colorful outliers (no sense grabbing a random beige), so we're evaluating it by its saturation.
    # With brightness, I think both saturation and brightness are important.
    hue_outlier        = colors64[:h][:outliers].any? ? get_highest_saturation(colors64[:h][:outliers], 2) : nil # Not a mistake.
    saturation_outlier = colors64[:s][:outliers].any? ? get_highest_saturation(colors64[:s][:outliers], 2) : nil
    brightness_outlier = colors64[:h][:outliers].any? ? get_highest_saturation_and_brightness(colors64[:h][:outliers]) : nil # Not a mistake.

    outliers += hue_outlier if hue_outlier
    outliers += saturation_outlier if saturation_outlier
    outliers += brightness_outlier if brightness_outlier

    num_left_to_add = total_to_extract - outliers.length

    results += colors16.first(num_left_to_add)
    results += outliers

    results
  end

  private

  def self.get_highest_saturation(outliers, num=1)
    outliers.sort_by { |o| o[:hsb][:s] }.last(num)
  end

  def self.get_highest_saturation_and_brightness(outliers)
    outliers.sort_by { |o| (o[:hsb][:s] + o[:hsb][:b]) }.last
  end

  def self.consolidate_outliers(data)
    data[:h][:outliers] + data[:s][:outliers] + data[:b][:outliers]
  end
end