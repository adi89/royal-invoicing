class CreateBillingDocsContacts < ActiveRecord::Migration
  def change
    create_table :billing_docs_contacts do |t|
      t.references :billing_doc
      t.references :contact
    end
  end
end
