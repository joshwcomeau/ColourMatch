class CreatePhotoColours < ActiveRecord::Migration
  def change
    create_table :photo_colours do |t|
      t.belongs_to  :photo
      t.belongs_to  :colour
      t.integer     :occurances
      t.string      :type
      t.timestamps
    end
  end
end
