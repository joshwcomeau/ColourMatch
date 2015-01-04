require 'five_hundred_api'

namespace :fhpx do 
  desc "Create a png featuring all the colors we'll be using"
  task quick: :environment do
    full_retrieve({page: 1, feature: 'fresh_today'}, recursive: false)
  end

  task all_fresh: :environment do
    full_retrieve({page: 1, feature: 'fresh_today'})
  end
end


def full_retrieve(opts, recursive: true)
  puts "Started retrieving page #{opts[:page]}."
  data = FiveHundredAPI.get_photos(opts)

  data["photos"].each do |p|
    Photo::SaveToDb.call(p) ? puts "Photo #{p.id} saved." : puts "Photo not saved."
  end

  if recursive && opts[:page] < data["total_pages"]
    opts[:page] += 1
    full_retrieve(opts)
  end
end