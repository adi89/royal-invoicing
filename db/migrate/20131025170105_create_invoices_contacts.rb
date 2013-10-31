class CreateInvoicesContacts < ActiveRecord::Migration
  def change
    create_table :invoices_contacts do |t|
      t.references :invoice
      t.references :contact
    end
  end
end
