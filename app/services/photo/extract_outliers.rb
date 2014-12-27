class Photo::ExtractOutliers
  def self.call(colour_data)
    outliers = []
    all_outliers = get_all_outliers(colour_data)

    outliers += get_highest_saturation_and_brightness(all_outliers, 8) if all_outliers.any?

    outliers = match_colours_to_db(outliers)

    limit_outliers_by_bins(outliers)
  end

  
  private

  def self.get_all_outliers(colors)
    (colors[:h][:outliers] + colors[:s][:outliers] + colors[:b][:outliers]).uniq
  end

  def self.get_highest_saturation_and_brightness(outliers, num=1)
    outliers.sort_by { |o| (o[:hsb][:s] + o[:hsb][:b]) }.last(num).reverse
  end

  def self.limit_outliers_by_bins(outliers)
    # We only want max 1 outlier per bin.
    bins = Bin.all
    bins_taken = []

    outliers.select do |o|
      bin = Bin::FindClosest.call(o[:lab])
      bins_taken << bin unless bins_taken.include? bin
    end
  end

  def self.match_colours_to_db(colour_data)
    colour_data.map do |c|
      Colour::FindClosest.call(c[:lab], false)
    end
  end

end