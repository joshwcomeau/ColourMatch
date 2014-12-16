require 'generate_colormap'
include GenerateColormap

namespace :colormap do 
  desc "Create a png featuring all the colors we'll be using"
  task create: :environment do
    get_colors_and_go
  end
end



def get_colors_and_go
  colors = Colour.all.map do |c|
    "##{c.hex}"
  end

  start(colors)
end