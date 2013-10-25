class AddFieldsToLineItems < ActiveRecord::Migration
  def change
      add_column :line_items, :note, :text
      add_column :line_items, :due_date, :date
  end
end
