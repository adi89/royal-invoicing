class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.decimal :total
      t.text :note
      t.string :title
      t.string :state
      t.string :kind
      t.string :due_date
      t.timestamps
    end
  end
end
