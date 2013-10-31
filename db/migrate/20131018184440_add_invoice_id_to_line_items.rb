class AddInvoiceIdToLineItems < ActiveRecord::Migration
  def change
     add_column :line_items, :invoice_id, :integer
    add_index :line_items, :invoice_id
  end
end
