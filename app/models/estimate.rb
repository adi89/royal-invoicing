# == Schema Information
#
# Table name: estimates
#
#  id         :integer          not null, primary key
#  total      :decimal(, )
#  note       :text
#  title      :string(255)
#  state      :string(255)
#  kind       :string(255)
#  due_date   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Estimate < ActiveRecord::Base
has_many :estimates_contacts
has_many :contacts, through: :estimates_contacts


end
