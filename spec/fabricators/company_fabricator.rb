# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  group_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

Fabricator(:company) do
  name "Subvrt"
end
