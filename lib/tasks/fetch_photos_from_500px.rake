require 'fetch_photos'
include FetchPhotos

namespace :fhpx do 
  desc "Create a png featuring all the colors we'll be using"
  task fresh: :environment do
    # Strategy: run this task at 11:30pm every day, pulling 'fresh' photos from 500px api one page at a time.
    # Iterate through the photos in each page of 100, and if the ID doesnt exist in the DB, add it.
    # (maybe don't even check if it already exists, but create it in a try/catch block, with a validation on px_id uniqueness?)
    # At the end of each page, check to see if the date is equal to today. If it isn't, stop fetching new pages.

    fetch_fresh_today
  end
end



def fetch_fresh_today
  data = fetch
  photos = data["photos"]

  photos.first(5).each do |p|
    puts "Fetching Photo #{p}"
    Photo::SaveToDb.call(p)
    puts "Photo saved to DB \n\n\n"
  end

  
end