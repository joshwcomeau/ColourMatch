class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.belongs_to :photo
      t.json :hsb
      t.json :lab
      t.timestamps
    end

    add_index :stats, :photo_id

  end
end
