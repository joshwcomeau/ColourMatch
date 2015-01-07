require 'rails_helper'
require 'initial_colour_setup'

RSpec.describe SearchController, :type => :controller do
  include InitialColourSetup
  before(:all) do 
    reset_a_few_colours
  end

  describe "GET :show" do

  end
end
