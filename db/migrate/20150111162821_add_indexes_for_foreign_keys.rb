class AddIndexesForForeignKeys < ActiveRecord::Migration
  def change
    remove_index :photos, :px_id
    add_index :photos, :from_500px
    add_index :photo_colours, [:photo_id, :closest_colour_id]
  end
end
