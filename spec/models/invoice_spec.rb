# == Schema Information
#
# Table name: invoices
#
#  id         :integer          not null, primary key
#  total      :decimal(, )
#  note       :text
#  state      :string(255)
#  kind       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#  due_date   :string(255)
#

require 'spec_helper'

describe Invoice do
  before(:each) do
    @invoice = Fabricate(:invoice)
  end

  describe '.create' do
    it 'is valid' do
      expect(@invoice.valid?).to eq true
    end
  end

  describe 'state machine' do
    it 'starts unpaid' do
      expect(@invoice.state).to eq 'unpaid'
    end
    it 'pay' do
      @invoice.pay
      expect(@invoice.state).to eq 'paid'
    end
    it 'goes from paid to unpaid' do
      @invoice.pay
      expect(@invoice.state).to eq 'paid'
      @invoice.unpay
      expect(@invoice.state).to eq 'unpaid'
    end
  end

  describe 'contacts sort' do
    it 'sorts contacts' do
      @invoice = Fabricate(:invoice)
      @invoice.contacts << [Fabricate(:contact), Contact.create(name: 'odie', email: 'bronsolino@gmail.com', company_id: Company.first.id)]
      @category = Invoice.where(kind: 'invoice')
      attribute = "contacts"
      forward = 'false'
      expect(Invoice.contacts_sort(attribute, @category, forward).first.contacts.first.name).to eq 'Kurt Russell'
    end
  end

  describe 'category sort' do
    it 'categorizes category' do
    @category = Invoice.where(kind: 'invoice')
    attribute = 'due_date'
    forward = 'false'
    Invoice.create(kind: 'invoice', total: 300, due_date: '10-2-2013')
    expect(Invoice.category_sorting(attribute, @category, forward).first.due_date).to eq '11-11-2013'
    end
  end

end
