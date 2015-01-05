class Rejig500pxPhotoData < ActiveRecord::Migration
  def change
    remove_column :photos, :px_description, :text
    remove_column :photos, :px_rating, :decimal
    remove_column :photos, :px_status, :integer
    
    add_column :photos, :from_500px, :boolean
  end
end
