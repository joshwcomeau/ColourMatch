class CreateColours < ActiveRecord::Migration
  def change
    create_table :colours do |t|
      t.integer :r
      t.integer :g
      t.integer :b
      t.string  :label
      t.timestamps
    end
  end
end
