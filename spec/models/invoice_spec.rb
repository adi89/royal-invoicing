

require 'spec_helper'

describe BillingDoc do
  before(:each) do
    @invoice = Fabricate(:billing_doc)
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
      @invoice = Fabricate(:billing_doc)
      @invoice.contacts << [Fabricate(:contact), Contact.create(name: 'odie', email: 'bronsolino@gmail.com', company_id: Company.first.id)]
      @category = BillingDoc.where(kind: 'invoice')
      attribute = "contacts"
      forward = 'asc'
      expect(BillingDoc.sort_by_contacts(attribute, forward).first.contacts.first.name).to eq 'Kurt Russell'
    end
  end

  describe 'category sort' do
    it 'categorizes category' do
    @category = BillingDoc.where(kind: 'invoice')
    attribute = 'due_date'
    forward = 'desc'
    BillingDoc.create(kind: 'invoice', total: 300, due_date: '10-2-2013')
    expect(BillingDoc.sort_by_attribute(attribute, forward).first.due_date).to eq '11-11-2013'
    end
  end

end
