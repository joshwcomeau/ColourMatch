class RenamePxImageToBeMoreGeneric < ActiveRecord::Migration
  def change
    rename_column :photos, :px_image, :image
  end
end
