

namespace :fivehundredpx do 
  desc "Create a png featuring all the colors we'll be using"
  task fetch_fresh_today: :environment do
    # Strategy: run this task at 11:30pm every day, pulling 'fresh' photos from 500px api one page at a time.
    # Iterate through the photos in each page of 100, and if the ID doesnt exist in the DB, add it.
    # (maybe don't even check if it already exists, but create it in a try/catch block, with a validation on px_id uniqueness?)
    # At the end of each page, check to see if the date is equal to today. If it isn't, stop fetching new pages.

    fetch_fresh_today
  end
end



def fetch_fresh_today
  date = Date.today
  # Call the module method that doesn't exist yet.
end