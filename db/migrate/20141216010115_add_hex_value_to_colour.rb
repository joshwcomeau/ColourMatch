class AddHexValueToColour < ActiveRecord::Migration
  def change
    add_column :colours, :hex, :string
  end
end
