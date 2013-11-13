class CreateBillingDocsUsers < ActiveRecord::Migration
  def change
    create_table :billing_docs_users do |t|
      t.references :billing_doc
      t.references :user
    end
  end
end
