class CreateBins < ActiveRecord::Migration
  def change
    create_table :bins do |t|
      t.integer :exemplar_id
      t.timestamps
    end
  end
end
