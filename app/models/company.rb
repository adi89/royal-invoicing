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

class Company < ActiveRecord::Base
  has_many :contacts
  belongs_to :group
  validates :name, presence: true
  validates_uniqueness_of :name
end
