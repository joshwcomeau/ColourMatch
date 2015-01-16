class AddIndexOnPxId < ActiveRecord::Migration
  def change
    add_index :photos, :px_id
  end
end
