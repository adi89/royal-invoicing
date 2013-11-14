# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Group do
  before(:each) do
    @group = Fabricate(:group)
  end

  describe '.create' do
    it 'is valid' do
      expect(@group.valid?).to eq true
    end
  end

  describe "associations" do
    it 'has many contacts' do
      company = Company.create(name: 'company')
      @group.contacts << Contact.create(name: "adi", email: "adi89@gmail.com", company_id: company.id)
      expect(@group.contacts.present?).to eq true
      expect(@group.contacts.first.company.present?).to eq true
    end
    it 'has many billing_docs' do
      @group.billing_docs << Fabricate(:billing_doc)
      expect(@group.billing_docs.present?).to eq true
    end
  end
end
