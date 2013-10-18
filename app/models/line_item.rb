# == Schema Information
#
# Table name: line_items
#
#  id             :integer          not null, primary key
#  quantity       :integer
#  price          :decimal(, )
#  created_at     :datetime
#  updated_at     :datetime
#  billing_doc_id :integer
#

class LineItem < ActiveRecord::Base
  belongs_to :billing_doc
end
