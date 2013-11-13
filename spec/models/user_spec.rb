# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  group_id               :integer
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
    @group = Fabricate(:group)
    @user = User.new(email: 'adi@gmail.com', password: 'akansha1' )
    @user.group = @group
    @user.billing_docs << Fabricate(:billing_doc)
    @user.save
  end

  describe '.create' do
    it 'is valid' do
      expect(@user.valid?).to eq true
    end
  end

  describe "associations" do
    it 'belongs to a group' do
      expect(@user.group.present?).to eq true
    end
    it 'has many contacts' do
      @user.contacts << Contact.create(email: 'alf@alfworld.com')
      expect(@user.contacts.present?).to eq true
    end
    it 'has many billing_docs' do
      expect(@user.billing_docs.present?).to eq true
    end
  end

end
