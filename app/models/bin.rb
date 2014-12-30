# == Schema Information
#
# Table name: bins
#
#  id          :integer          not null, primary key
#  exemplar_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Bin < ActiveRecord::Base
  # Bins are used to group similar colours. We NEVER save a rounded color's value.
  # Bins exist to help us avoid picking too many similar colors for outliers,
  # and to find closest colours more efficiently.
  has_many :colours
  belongs_to :exemplar, class_name: 'Colour'
end
