class Photo::ExtractOutliers
  def self.call(colour_data)
    all_outliers = get_all_outliers(colour_data)

    outliers = sort_by_zscore(all_outliers).first(5)

    # We want the outlier that is most saturated/bright, as well.
    highest_sat = sort_by_sat(all_outliers).first
    outliers.unshift(highest_sat)

    binding.pry


    outliers = limit_outliers_by_bins(outliers)


    match_colours_to_db(outliers).uniq { |c| c[:colour] }
  end

  
  private

  def self.get_all_outliers(colours)
    (colours[:h][:outliers] + colours[:s][:outliers] + colours[:b][:outliers]).uniq
  end

  def self.sort_by_zscore(colours)
    colours.sort { |a, b| b[:z_score] <=> a[:z_score] }
  end

  def self.sort_by_sat(colours)
    colours.sort { |a, b| b[:hsb][:s] <=> a[:hsb][:s] }
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
      {
        type:       "outlier",
        colour:     Colour::FindClosest.call(c[:lab], false),
        occurances: c[:occurances]
      }
    end
  end

end