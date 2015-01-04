class TotallyRejiggingPhotoColourModel < ActiveRecord::Migration
  def change
    rename_column :photo_colours, :colour_id, :closest_colour_id
    add_column :photo_colours, :hex, :string
    add_column :photo_colours, :lab, :json
    add_column :photo_colours, :rgb, :json
    add_column :photo_colours, :hsb, :json
    add_column :photo_colours, :label, :string
  end
end
