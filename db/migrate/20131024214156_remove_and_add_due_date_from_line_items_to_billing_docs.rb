class RemoveAndAddDueDateFromLineItemsToBillingDocs < ActiveRecord::Migration
  def change
    remove_column :line_items, :due_date
    add_column :billing_docs, :due_date, :string
  end
end
