class ChangeTypeToKindOnBillingDocs < ActiveRecord::Migration
  def change
   rename_column :billing_docs, :type, :kind
  end
end
