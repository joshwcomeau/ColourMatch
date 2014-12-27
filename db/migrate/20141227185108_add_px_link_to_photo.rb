class AddPxLinkToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :px_link, :string
  end
end
