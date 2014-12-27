class ChangePxImagesToPxImage < ActiveRecord::Migration
  def change
    remove_column :photos, :px_images, :array
    add_column    :photos, :px_image, :string
  end
end
