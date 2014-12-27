class ChangeOccurancesToCoverageOnPhotoColour < ActiveRecord::Migration
  def change
    remove_column :photo_colours, :occurances, :integer
    add_column :photo_colours, :coverage, :float
  end
end
