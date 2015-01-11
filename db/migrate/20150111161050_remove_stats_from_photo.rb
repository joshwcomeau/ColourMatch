class RemoveStatsFromPhoto < ActiveRecord::Migration
  def change
    remove_column :photos, :hue_mean, :float
    remove_column :photos, :hue_deviation, :float
    remove_column :photos, :saturation_mean, :float
    remove_column :photos, :saturation_deviation, :float
    remove_column :photos, :brightness_mean, :float
    remove_column :photos, :brightness_deviation, :float 
  end
end
