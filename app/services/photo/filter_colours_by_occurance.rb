class Photo::FilterColoursByOccurance
  def self.call(colour_data, minimum: 0.001)
    min_occurance = colour_data[:pixels] * minimum

    colour_data[:colours].select { |c| c[:occurances] >= min_occurance }
  end
end