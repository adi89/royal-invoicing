# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  group_id   :integer
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
    it 'has a unique name' do
      subvrt = Company.new(name: "Subvrt")
      expect(subvrt.save).to eq false
    end
  end

end
