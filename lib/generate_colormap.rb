require 'json'

module GenerateColormap

  def self.start
    puts "Enter file path to get colors from"
    path = gets.chomp
    create(path)
  end

  def self.create(path)
    json = JSON.parse(File.open(path, "r").read)

    puts json[0]
  end

  def self.format(colors)
    # Format is {"x"=>93, "y"=>138, "z"=>168, "label"=>"Air Force blue"}
    colors.map do |c|
      ['x','y','z']
    end
  end
end


GenerateColormap.start