class CreateEstimatesContacts < ActiveRecord::Migration
  def change
    create_table :estimates_contacts do |t|
      t.references :estimate
      t.references :contact
    end
  end
end
