# == Schema Information
#
# Table name: contacts
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  email          :string(255)
#  job_title      :string(255)
#  phone_number   :string(255)
#  website        :string(255)
#  address        :string(255)
#  twitter_handle :string(255)
#  photo          :string(255)
#  company_id     :integer
#  group_id       :integer
#  created_at     :datetime
#  updated_at     :datetime
#

Fabricator(:contact) do
  name "Kurt Russell"
  email "kurt_russell@yahoo.com"
  job_title "Pliskin"
  group
  company
end
