require 'initial_colour_setup'
include InitialColourSetup



Colour.destroy_all
Bin.destroy_all
# Reset all the IDs so we aren't perpetually climbing up
ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }


reset_colours
reset_bins
