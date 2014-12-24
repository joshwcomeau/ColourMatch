class AddHsbToColour < ActiveRecord::Migration
  def change
    add_column :colours, :hsb, :json

  end
end
