# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  photo_id   :integer
#  hsb        :json
#  lab        :json
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Stat, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
