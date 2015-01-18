class DashboardController < ApplicationController
  def index
    # On page load we want to throw a handful of suggestions
    gon.suggestions = Photo
      .where(from_500px: false)
      .order("created_at DESC")
      .first(4)
      .map do |p|
        {
          photo:    p,
          palette:  p.sorted_colours
        }
      end
  end
end
