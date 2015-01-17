require 'five_hundred_api'

namespace :fhpx do 
  desc "Create a png featuring all the colors we'll be using"

  # Quickly nab a few photos for testing purposes.
  task quick: :environment do
    full_retrieve({page: 1, feature: 'fresh_today', rpp: 20}, mode: :quick)
  end

  task :thorough, [:starting_page, :feature] => [:environment] do |t, args|
    args.with_defaults(starting_page: 1, feature: 'fresh_today', rpp: 200)
    full_retrieve({ page: args.starting_page, feature: args.feature })
  end

  task :last_24h, [:starting_page, :feature] => [:environment] do |t, args|
    args.with_defaults(starting_page: 1, feature: 'fresh_today')
    full_retrieve({ page: args.starting_page, feature: args.feature }, mode: :last24h)
  end
end


def full_retrieve(opts, mode: :recursive)
  puts "Started retrieving page #{opts[:page]}."
  data = FiveHundredAPI.get_photos(opts)
  puts "#{data["total_pages"]} total pages"

  data["photos"].each do |p|
    p[:from_500px] = true
    puts Photo::SaveToDb.call(p) ? "YES, Photo #{p['id']} saved." : "NO, Photo #{p['id']} rejected."
  end

  if mode == :recursive && opts[:page] <= 100 
    opts[:page] += 1
    full_retrieve(opts)
  elsif mode == :last24h && within_last_24h?(data)
    opts[:page] += 1
    full_retrieve(opts, mode: :last24h)
  end
end

def within_last_24h?(data)
  last_photo_date   = Time.parse( data["photos"].last["created_at"] )
  elapsed_time_in_s = Time.now - last_photo_date
  elapsed_time_in_s < 86400
end