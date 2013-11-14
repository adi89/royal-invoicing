# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Group < ActiveRecord::Base
  has_many :users
  has_many :billing_docs
  has_many :contacts
  has_many :companies
  validates :name, presence: true
end