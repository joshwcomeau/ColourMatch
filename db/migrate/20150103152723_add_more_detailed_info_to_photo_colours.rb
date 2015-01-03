class AddMoreDetailedInfoToPhotoColours < ActiveRecord::Migration
  def change
    add_column :photo_colours, :outlier_channel, :string
    add_column :photo_colours, :z_score, :float
  end
end