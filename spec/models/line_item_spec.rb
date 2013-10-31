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

require 'spec_helper'

describe LineItem do
  before(:each) do
    @line_item = Fabricate(:line_item)
  end

  describe '.create' do
    it 'is valid' do
      expect(@line_item.valid?).to eq true
    end
  end

  describe "associations" do
    it 'belongs to a billing doc' do
      expect(@line_item.billing_doc.present?).to eq true
    end
  end
end
