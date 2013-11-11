# == Schema Information
#
# Table name: invoices
#
#  id         :integer          not null, primary key
#  total      :decimal(, )
#  note       :text
#  state      :string(255)
#  kind       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#  due_date   :string(255)
#


# == Schema Information
#
# Table name: billing_docs
#
#  id         :integer          not null, primary key
#  total      :decimal(, )
#  note       :text
#  state      :string(255)
#  kind       :string(255)
#  contact_id :integer
#  created_at :datetime
#  updated_at :datetime
#
Fabricator(:invoice) do
  title 'example invoice'
  kind "invoice"
  total 432
  due_date '11-11-2013'
end

