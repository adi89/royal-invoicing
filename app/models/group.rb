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
  has_many :users, :inverse_of => :group
  validates :name, presence: true

  def invoices(kind)
    self.users.map{|i| i.invoices.where(kind: kind).where('total is NOT NULL')}.flatten
  end
end