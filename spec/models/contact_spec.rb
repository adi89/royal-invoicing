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
#  group_id       :integer
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
    it 'belongs to a group' do
      expect(@contact.group.present?).to eq true
    end
    it 'belongs to a company' do
      expect(@contact.company.present?).to eq true
    end
  end

  describe 'validations' do
    it 'only creates concacts w unique emails' do
      contact = Contact.create(name: "odie", email: @contact.email, company_id: @contact.company.id)
      expect(contact.errors.messages[:email].first).to eq "has already been taken"
      contact.email = "a_unique_email@gmail.com"
      expect(contact.save).to eq true
    end
    it 'validates the presence of a name' do
      contact = Contact.create(email: 'bronsolino@gmail.com', company_id: @contact.company.id)
      expect(contact.new_record?).to eq true
      contact.name = "yabish"
      expect(contact.save).to eq true
    end
    it 'validates the presence of a company' do
      contact= Contact.new(name: 'odie', email: 'bronsolino@gmail.com')
      expect(contact.save).to eq false
      contact.company = Company.create(name: "bambam")
      expect(contact.save).to eq true
    end
  end

  describe 'scope' do

    before(:each) do
    @contact2 = Contact.create(name: 'odie', email: 'bronsolino@gmail.com', company_id: Company.first.id)
      @group = Group.create(name: 'sample')
      # @user = User.create(email: 'hd@a.com', password: 'derpfjdy32', group_id: @group.id)
      @group.contacts << [@contact, @contact2]
      @contact.billing_docs << Fabricate(:billing_doc)
    end
    it 'finds the top contacts' do
      expect(Contact.top_contacts(@group).first).to eq @contact
    end
  end
end
