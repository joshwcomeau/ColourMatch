class DashboardController < ApplicationController
  def index
    # On page load we want to throw a handful of suggestions
    @suggestions  = Photo.where(from_500px: false).order("created_at DESC").first(4)
    @column_width = 12 / @suggestions.count
  end
end
