# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Company < ActiveRecord::Base
  has_many :contacts, :inverse_of => :company
  validates :name, presence: true
  validates_uniqueness_of :name
end
