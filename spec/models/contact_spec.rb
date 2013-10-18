# == Schema Information
#
# Table name: contacts
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  email          :string(255)
#  job_title      :string(255)
#  phone_number   :string(255)
#  website        :string(255)
#  address        :string(255)
#  twitter_handle :string(255)
#  photo          :string(255)
#  company_id     :integer
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Contact do
  before(:each) do
    @contact = Fabricate(:contact)
  end

  describe '.create' do
    it 'is valid' do
      expect(@contact.valid?).to eq true
    end
  end

  describe "associations" do
    it 'belongs to a user' do
      expect(@contact.user.present?).to eq true
    end
    it 'belongs to a company' do
      expect(@contact.company.present?).to eq true
    end
  end
end