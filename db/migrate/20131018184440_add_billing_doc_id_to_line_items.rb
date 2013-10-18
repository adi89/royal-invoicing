class AddBillingDocIdToLineItems < ActiveRecord::Migration
  def change
     add_column :line_items, :billing_doc_id, :integer
    add_index :line_items, :billing_doc_id
  end
end
