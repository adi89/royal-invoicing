class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :job_title
      t.string :phone_number
      t.string :website
      t.string :address
      t.string :twitter_handle
      t.string :photo
      t.references :company
      t.references :user
      t.timestamps
    end
  end
end
