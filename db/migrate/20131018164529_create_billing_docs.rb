class CreateBillingDocs < ActiveRecord::Migration
  def change
    create_table :billing_docs do |t|
      t.decimal :total
      t.text :note
      t.string :state
      t.string :kind
      t.references :contact
      t.timestamps
    end
  end
end
