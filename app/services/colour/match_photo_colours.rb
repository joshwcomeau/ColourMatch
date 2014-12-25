class Colour::MatchPhotoColours
  def self.call(colours)
    # FORMAT: At this point, colours is an array like this:
    # { 
    #   :occurances=>3757,
    #   :rgb=>{:r=>52, :g=>60, :b=>55},
    #   :hsb=>{:h=>143, :s=>13, :b=>24},
    #   :lab=>{:l=>24.441932180961714, :a=>-4.53291600165287, :b=>1.957674700759171}
    # }

    colours.map do |c|
      # We're going to keep stuff in the same format for now. 
      # I really need to standardize how this data is kept throughout the app.
      match = Colour::FindClosest.call(c[:lab])
      c[:rgb] = match[:rgb]
      c[:hsb] = match[:hsb]
      c[:lab] = match[:lab]
      c
    end
  end

end