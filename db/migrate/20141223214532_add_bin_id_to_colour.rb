class AddBinIdToColour < ActiveRecord::Migration
  def change
    add_column :colours, :bin_id, :integer
  end
end
