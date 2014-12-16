require 'json'

module GenerateColormap
  def start(colors)
    date_string = Date.today.strftime("%Y-%m-%d")
    filepath    = "lib/assets/images/colormap_#{date_string}.png"
    # alright, this is going to be a fucking long terminal command. Hopefully there aren't limits.
    query_string = "convert -size #{colors.length}x1 xc:white "
    colors.each_with_index do |c, i|
      query_string += "-fill '##{c}' -draw 'point #{i},0' "
    end
    query_string += filepath

    system(query_string)
  end 
end