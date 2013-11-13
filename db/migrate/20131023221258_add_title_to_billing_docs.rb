class AddTitleToBillingDocs < ActiveRecord::Migration
  def change
    add_column :billing_docs, :title, :string
  end
end
