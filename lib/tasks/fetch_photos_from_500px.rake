require 'five_hundred_api'

namespace :fhpx do 
  desc "Create a png featuring all the colors we'll be using"
  task quick: :environment do
    full_retrieve({page: 1, feature: 'fresh_today'}, recursive: false)
  end

  task :thorough, [:starting_page, :feature] => [:environment] do |t, args|
    args.with_defaults(starting_page: 1, feature: 'fresh_today')
    full_retrieve({ page: args.starting_page, feature: args.feature })
  end
end


def full_retrieve(opts, recursive: true)
  puts "Started retrieving page #{opts[:page]}."
  data = FiveHundredAPI.get_photos(opts)
  puts "#{data["total_pages"]} total pages"

  data["photos"].each do |p|
    p[:from_500px] = true
    puts Photo::SaveToDb.call(p) ? "YES, Photo #{p['id']} saved." : "NO, Photo #{p['id']} rejected."
  end

  if recursive && opts[:page] <= 100 # regrettably, the API doesn't seem to accept page numbers > 100
    opts[:page] += 1
    full_retrieve(opts)
  end
end