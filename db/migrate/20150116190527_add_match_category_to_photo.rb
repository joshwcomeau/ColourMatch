class AddMatchCategoryToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :match_category, :string
    add_index :photos, :match_category
  end
end
