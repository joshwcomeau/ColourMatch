class Photo::CompileToDominant
  def self.call(commons, outliers, palette_size=6, max_outliers=2)
    return commons.first(palette_size) if outliers.empty?

    # We want to prioritize outliers that are dissimilar from our common colours.
    # Let's get the HSB means/sdev for our first common 6, and measure z-score for our outliers
    stats = get_starter_stats(commons)
    outliers = remove_any_duplicates(commons.first(4), outliers)
    outliers = add_in_zscores(outliers, stats)
    outliers = sort_by_zscores(outliers)

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
        unique = false if c[:colour] == o[:colour]
      end
      unique
    end
  end 
  
  def self.sort_by_zscores(outliers)
    outliers.sort do |a, b| 
      (b[:zscore_from_common][:hue] + b[:zscore_from_common][:sat] + b[:zscore_from_common][:brit]) <=> 
      (a[:zscore_from_common][:hue] + a[:zscore_from_common][:sat] + a[:zscore_from_common][:brit])
    end
  end

  def self.get_starter_stats(commons)
    hues, sats, brits = [], [], []
    commons.map do |c| 
      hues  << c[:colour][:hsb]['h']
      sats  << c[:colour][:hsb]['s']
      brits << c[:colour][:hsb]['b']
    end
    
    results = {
      hue: {
        mean: Maths.mean(hues),
        deviation: Maths.standard_deviation(hues)
      },
      sat: {
        mean: Maths.mean(sats),
        deviation: Maths.standard_deviation(sats)
      },
      brit: {
        mean: Maths.mean(brits),
        deviation: Maths.standard_deviation(brits)
      }
    }
  end

  def self.add_in_zscores(outliers, stats)
    outliers.map do |o|
      o[:zscore_from_common] = {
        hue:  Maths.z_score(o[:colour][:hsb]["h"], mean: stats[:hue][:mean], deviation: stats[:hue][:deviation]).abs,
        sat:  Maths.z_score(o[:colour][:hsb]["s"], mean: stats[:sat][:mean], deviation: stats[:sat][:deviation]).abs,
        brit: Maths.z_score(o[:colour][:hsb]["b"], mean: stats[:brit][:mean], deviation: stats[:brit][:deviation]).abs
      }
      o
    end
  end 
end