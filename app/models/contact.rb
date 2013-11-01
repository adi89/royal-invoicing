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
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Contact < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
  has_many :invoices_contacts
  has_many :invoices, through: :invoices_contacts
  has_many :estimates_contacts
  has_many :estimates, through: :estimates_contacts
  accepts_nested_attributes_for :company
  mount_uploader :photo, ContactUploader
end
