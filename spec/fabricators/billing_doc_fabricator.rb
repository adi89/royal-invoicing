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
#  title      :string(255)
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
Fabricator(:billing_doc) do
  kind "estimate"
  state "sent"
  contact
end

