require 'five_hundred_api'

namespace :fhpx do 
  desc "Create a png featuring all the colors we'll be using"

  # Quickly nab a few photos for testing purposes.
  task quick: :environment do
    full_retrieve({page: 1, feature: 'fresh_today', rpp: 20}, mode: :quick)
  end

  task :thorough, [:starting_page, :feature] => [:environment] do |t, args|
    args.with_defaults(starting_page: 1, feature: 'fresh_today', rpp: 200)
    full_retrieve({ page: args.starting_page.to_i, feature: args.feature, rpp: args.rpp })
  end

  task :until_caught_up, [:starting_page, :feature] => [:environment] do |t, args|
    args.with_defaults(starting_page: 1, feature: 'fresh_today', rpp: 200)
    
    last_time_from_database = Photo.where(from_500px: true).order("created_at DESC").first.created_at
    full_retrieve({ page: args.starting_page.to_i, feature: args.feature, rpp: args.rpp }, mode: :until_caught_up, run_until: last_time_from_database)
  end
end

# To use in terminal: bundle exec rake fhpx:thorough[1,'fresh_today']
# Important to not have any spaces in that 'array'.


def full_retrieve(opts, mode: :recursive, run_until: nil)
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
  elsif mode == :until_caught_up && within_time?(data, run_until) && opts[:page] <= 100 
    
    opts[:page] += 1
    full_retrieve(opts, mode: :until_caught_up, run_until: run_until)
  end
end

def within_time?(data, last_time_from_database)
  last_time_from_500px   = Time.parse( data["photos"].last["created_at"] )
  last_time_from_database < last_time_from_500px
end