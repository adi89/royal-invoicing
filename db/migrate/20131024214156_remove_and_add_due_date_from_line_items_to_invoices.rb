class RemoveAndAddDueDateFromLineItemsToInvoices < ActiveRecord::Migration
  def change
    remove_column :line_items, :due_date
    add_column :invoices, :due_date, :string
  end
end
