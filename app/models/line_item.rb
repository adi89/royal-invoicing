# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  quantity   :integer
#  price      :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#  invoice_id :integer
#  note       :text
#


class LineItem < ActiveRecord::Base
  belongs_to :invoice
end
