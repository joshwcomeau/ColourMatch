class Bin < ActiveRecord::Base
  has_many :colours
  belongs_to :exemplar, class_name: 'Colour'
end
