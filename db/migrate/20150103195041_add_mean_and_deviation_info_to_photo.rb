class AddMeanAndDeviationInfoToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :hue_mean, :float
    add_column :photos, :hue_deviation, :float
    add_column :photos, :saturation_mean, :float
    add_column :photos, :saturation_deviation, :float
    add_column :photos, :brightness_mean, :float
    add_column :photos, :brightness_deviation, :float
  end
end
