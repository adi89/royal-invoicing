class AddEstimateIdToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :estimate_id, :integer
    add_index :line_items, :estimate_id
  end
end
