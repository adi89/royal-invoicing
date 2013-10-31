class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.decimal :total
      t.text :note
      t.string :state
      t.string :type
      t.timestamps
    end
  end
end
