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

class Contact < ActiveRecord::Base
  belongs_to :company
  belongs_to :group
  has_many :billing_docs_contacts
  has_many :billing_docs, through: :billing_docs_contacts
  accepts_nested_attributes_for :company, :reject_if => :no_company
  mount_uploader :photo, ContactUploader
  validates_associated :company
  validates_presence_of :company_id, :unless => Proc.new() {|r| r.company}
  validates_presence_of :name
  validates_uniqueness_of :email

  def no_company(attributes)
    attributes["name"].blank?
  end

  def self.top_contacts(grouping)
   grouping.contacts.joins(:billing_docs).order('count(billing_docs.id) ASC').group('contacts.id')
  end
end