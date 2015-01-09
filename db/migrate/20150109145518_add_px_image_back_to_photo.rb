class AddPxImageBackToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :px_image, :string
  end
end
