class AddLabColoursToColour < ActiveRecord::Migration
  def change
    add_column :colours, :lab, :json
    add_column :colours, :rgb, :json

    remove_column :colours, :r, :integer
    remove_column :colours, :g, :integer
    remove_column :colours, :b, :integer
  end
end
