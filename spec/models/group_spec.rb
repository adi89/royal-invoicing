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
    it 'has many users' do
      @group.users << Fabricate(:user)
      expect(@group.users.present?).to eq true
    end
  end

  describe 'invoices' do
    it 'filters invoices' do
      user = Fabricate(:user)
      @group.users << user
      user.invoices << [Fabricate(:invoice),  Invoice.create(kind: 'estimate'),Invoice.create(kind: 'invoice')]
      expect(@group.invoices('invoice').count).to eq 1
    end
  end
end
