class AddIndexesToPhotos < ActiveRecord::Migration
  def change
    add_index :photos, :px_id
    add_index :photos, :px_images, using: 'gin'
  end
end
