require "spec_helper"
require 'features/shared/login_helper'
include LoginHelper

describe "BillingDocs" do
  describe "GET /groups/:id/invoice " do
    it "should have a create invoice button", js: true do
      user = Fabricate(:user)
      visit root_path
      login_to_system(user)
      click_link "Invoices"
      page.should have_link("Create invoice")
    end
  end
  describe "GET /groups/:id/estimate " do
    it "should have a create estimate", js: true do
      user = Fabricate(:user)
      visit root_path
      login_to_system(user)
      click_link "Estimates"
      page.should have_link("Create estimate")
    end
  end
  describe "GET /groups/:id/invoice/new" do
    it 'should have a invoice form', js: true do
      user = Fabricate(:user)
      visit root_path
      login_to_system(user)
      click_link "Invoices"
      click_link "Create invoice"
      page.should have_button("Create Pending")
    end
  end
  describe "GET /groups/:id/estimate/new" do
    it 'should have a estimate form', js: true do
      user = Fabricate(:user)
      visit root_path
      login_to_system(user)
      click_link "Estimates"
      click_link "Create estimate"
      page.should have_button("Create Estimate")
    end
  end
  describe "POST groups/:id/invoice" do
    it 'should post and create a new invoice', js: true do
      user = Fabricate(:user)
      contact = Contact.new(name: "John", email: "JSmith@gmail.com")
      contact.company = Company.create(name: "Initech")
      user.group.contacts << contact
      user.save
      visit root_path
      login_to_system(user)
      click_link "Invoices"
      click_link "Create invoice"
      fill_in("Title", with: "NewInvoiceTest")
      fill_in("Note", with: "lorem ipsum dolor")
      fill_in("Due Date", with: "12/11/2013")
      page.find_by_id('invoice_id').find("option[value='1']").select_option
      fill_in("billing_doc_line_items_attributes_0_note", with: "testcharge")
      fill_in("billing_doc_line_items_attributes_0_quantity", with: "2")
      fill_in("billing_doc_line_items_attributes_0_price", with: "200")
      click_button "Create Pending"
      page.should have_content "Paid?"
    end
  end
  describe "POST groups/:id/estimate" do
    before(:each) do
      @user = Fabricate(:user)
      @contact = Contact.new(name: "John", email: "JSmith@gmail.com")
      @contact.company = Company.create(name: "Initech")
      @user.group.contacts << @contact
      @user.save
      visit root_path
      login_to_system(@user)
      click_link "Estimates"
      click_link "Create estimate"
    end
    it 'should post and create a new estimate', js: true do
      fill_in("Title", with: "NewInvoiceTest")
      fill_in("Note", with: "lorem ipsum dolor")
      page.find_by_id('invoice_id').find("option[value='1']").select_option
      fill_in("billing_doc_line_items_attributes_0_note", with: "testcharge")
      fill_in("billing_doc_line_items_attributes_0_quantity", with: "2")
      fill_in("billing_doc_line_items_attributes_0_price", with: "200")
      click_button "Create Estimate"
      page.should have_content "Make Invoice"
    end
    it 'should make a new contact', js: true do
      click_link "New Contact?"
      fill_in "name", with: "Adi"
      fill_in "email", with: "adi-s89@gmail.com"
      fill_in "company name", with: "Subvrt"
      click_button "Save Contact Data"
      find("#invoice_id").should have_content "Adi"
    end
    it 'should add another line item', js: true do
      click_link "Add Line Item"
      page.all('.line-item-row').count.should eql(2)
    end
    it 'should delete that line item', js: true do
      click_link "Add Line Item"
      find('.line-item-row:last-child td .remove-line-item').click
      page.all('.line-item-row').count.should eql(1)
  end
end
  describe "show" do
    it 'should show the invoice', js: true do
      user = Fabricate(:user)
      user.group.billing_docs << Fabricate(:billing_doc)
      user.save
      visit root_path
      login_to_system(user)
      click_link "Invoices"
      click_link(user.group.billing_docs.first.title)
      page.should have_link "Paid?"
    end
  end
  describe "show" do
    it 'should show the estimate', js: true do
      user = Fabricate(:user)
      user.group.billing_docs << Fabricate(:billing_doc, kind: "estimate")
      user.save
      visit root_path
      login_to_system(user)
      click_link "Estimates"
      click_link(user.group.billing_docs.first.title)
      page.should have_link "Make Invoice"
    end
  end
  describe "show" do
    it 'should make into invoice', js: true do
      user = Fabricate(:user)
      user.group.billing_docs << Fabricate(:billing_doc, kind: "estimate")
      user.save
      visit root_path
      login_to_system(user)
      click_link "Estimates"
      click_link(user.group.billing_docs.first.title)
      click_link "Make Invoice"
      click_link "Invoices"
      page.should have_content "#{user.group.billing_docs.first.title}"
    end
  end
  describe "edit/update invoice" do
    it 'should show the edit page from the show page and then update', js: true do
      user = Fabricate(:user)
      user.group.billing_docs << Fabricate(:billing_doc)
      user.group.billing_docs.first.line_items << LineItem.create(quantity: 1, price: 200, note: "you owe me")
      user.save
      visit root_path
      login_to_system(user)
      click_link "Invoices"
      click_link(user.group.billing_docs.first.title)
      click_link('Edit')
      fill_in("billing_doc_line_items_attributes_0_price", with: "100")
      page.should have_button "Edit Invoice"
      click_button "Edit Invoice"
      page.should have_content "#{user.group.billing_docs.first.title} updated successfully!"
    end
  end
  describe "edit/update estimate" do
    it 'should show the edit page from the show page and then update', js: true do
      user = Fabricate(:user)
      user.group.billing_docs << Fabricate(:billing_doc, kind: "estimate")
      user.group.billing_docs.first.line_items << LineItem.create(quantity: 1, price: 200, note: "you owe me")
      user.save
      visit root_path
      login_to_system(user)
      click_link "Estimates"
      click_link(user.group.billing_docs.first.title)
      click_link('Edit')
      fill_in("billing_doc_line_items_attributes_0_price", with: "100")
      page.should have_button "Edit Estimate"
      click_button "Edit Estimate"
      page.should have_content "Successfully updated"
    end
  end
  describe 'sorting' do
    it 'should sort on the invoice index page', js: true do
      Capybara.default_wait_time = 5
      user = Fabricate(:user)
      user.group.billing_docs << [Fabricate(:billing_doc), Fabricate(:billing_doc, due_date: "12/12/2013")]
      user.save
      visit root_path
      login_to_system(user)
      click_link "Invoices"
      click_link "Due"
      find("#invoice-table-entries .line-item-show-row td:first-child", :text => "12/12/2013")
    end
  end
end