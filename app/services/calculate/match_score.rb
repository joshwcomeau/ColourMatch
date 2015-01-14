class Calculate::MatchScore
  def self.call(mode, data, p2)
    score = nil

    if mode == 'photo'
      c1    = { l: data.stat.lab['l']['mean'], a: data.stat.lab['a']['mean'], b: data.stat.lab['b']['mean'] }
    elsif mode == 'colour'
      c1 = data[:lab]
    end
 

    c2    = { l: p2.stat.lab['l']['mean'], a: p2.stat.lab['a']['mean'], b: p2.stat.lab['b']['mean'] }
    dist  = Calculate::Distance.call(c1, c2)
    score = Calculate::NormalizedDistance.call(dist)
    score.round(2)

  end

end