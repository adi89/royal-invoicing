class CreateInvoicesUsers < ActiveRecord::Migration
  def change
    create_table :invoices_users do |t|
      t.references :invoice
      t.references :user
    end
  end
end
