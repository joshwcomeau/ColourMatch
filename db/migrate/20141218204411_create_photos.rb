class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string  :px_images, array: true
      t.integer :px_id
      t.string  :px_name
      t.text    :px_description
      t.integer :px_category
      t.json    :px_user
      t.decimal :px_rating
      t.integer :px_status
      t.boolean :px_for_sale
      t.boolean :px_store_download
      t.integer :px_license_type
      t.boolean :px_privacy
      t.timestamps
    end
  end
end
