class ChangeTypeToOutlierBoolean < ActiveRecord::Migration
  def change
    remove_column :photo_colours, :type, :string
    add_column :photo_colours, :outlier, :boolean
  end
end
