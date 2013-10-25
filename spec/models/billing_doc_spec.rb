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
#  due_date   :string(255)
#

require 'spec_helper'

describe BillingDoc do
  before(:each) do
    @billing_doc = Fabricate(:billing_doc)
  end

  describe '.create' do
    it 'is valid' do
      expect(@billing_doc.valid?).to eq true
    end
  end

  describe "associations" do
    it 'has and belongs to a contact' do
      @billing_doc.contacts << Fabricate(:contact)
      expect(@billing_doc.contacts.first.present?).to eq true
    end
  end
end
