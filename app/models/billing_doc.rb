# == Schema Information
#
# Table name: billing_docs
#
#  id         :integer          not null, primary key
#  total      :decimal(, )
#  note       :text
#  state      :string(255)
#  kind       :string(255)
#  contact_id :integer
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#

class BillingDoc < ActiveRecord::Base
  belongs_to :contact
  has_many :line_items

  state_machine :state, initial: :unpaid do
  event :pay do
      transition all => :paid
    end
    event :unpay do
      transition all => :unpaid
    end
  end

  state_machine :kind , initial: :pending do
    event :invoice do
      transition all => :invoice
    end
    event :estimate do
      transition :pending => :estimate
    end
  end

accepts_nested_attributes_for :line_items
end


# open/closed for invoice  (so true or false or null, don't show that column )
# not applicable to estimate

# invoice / estimate
