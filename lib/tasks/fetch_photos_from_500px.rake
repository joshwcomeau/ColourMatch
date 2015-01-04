require 'five_hundred_api'
include FiveHundredAPI

namespace :fhpx do 
  desc "Create a png featuring all the colors we'll be using"
  task quick: :environment do
    # (maybe don't even check if it already exists, but create it in a try/catch block, with a validation on px_id uniqueness?)
    # At the end of each page, check to see if the date is equal to today. If it isn't, stop fetching new pages.

    quick
  end

  task all_fresh: :environment do
    full_retrieve({page: 1, feature: 'fresh_today'})
  end
end



def quick
  data = get_photos
  photos = data["photos"]

  photos.first(2).each do |p|
    puts "Fetching Photo #{p}"
    Photo::SaveToDb.call(p)
    puts "Photo saved to DB \n\n\n"
  end
end

def full_retrieve(opts, recursive: true)
  # Recursive, homeslice!
  # Call this method with ever-increasing page numbers.
  # End case is when we've reached the 'total_pages' integer from the API.
  data = get_photos(opts)

  data["photos"].each_with_index do |p, i|
    puts "Fetching Photo ##{i} with px_id #{p["id"]} on page #{data["current_page"]}"
    Photo::SaveToDb.call(p)
  end

  if recursive && opts[:page] < 10 # data["total_pages"]
    opts[:page] += 1
    puts "CURRENT OPTIONS: #{opts}"
    full_retrieve(opts)
  end
end