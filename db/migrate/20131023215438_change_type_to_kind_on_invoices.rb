class ChangeTypeToKindOnInvoices < ActiveRecord::Migration
  def change
   rename_column :invoices, :type, :kind
  end
end
