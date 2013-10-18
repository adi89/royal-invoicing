# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Company do
  before(:each) do
    @company = Fabricate(:company)
  end

  describe '.create' do
    it 'is valid' do
      expect(@company.valid?).to eq true
    end
  end

  describe "associations" do
    it 'belongs to a contact' do
      @company.contacts << Fabricate(:contact)
      expect(@company.contacts.present?).to eq true
    end
  end
end