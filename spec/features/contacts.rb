require "spec_helper"
require 'features/shared/login_helper'
include LoginHelper

describe "Contacts" do
  describe "GET /groups/:id/contact " do
    it "should have a create contact", js: true do
      user = Fabricate(:user)
      visit root_path
      login_to_system(user)
      click_link "Manage Contacts"
      page.should have_link("Create Contact")
    end
  end
  describe 'get /groups/:id/contact/:contact_id' do
    it 'should show the contact page', js: true do
      user = Fabricate(:user)
      contact = Contact.new(name: "adi", email: "adi@gmail.com")
      contact.company = Company.create(name: "initech")
      user.group.contacts << contact
      user.save
      visit root_path
      login_to_system(user)
      click_link "Manage Contacts"
      click_link(user.group.contacts.first.name)
      page.should have_content "See All Contacts"
    end
  end
    describe "POST groups/:id/contact", js: true do
    it 'should post and create a new contact' do
      user = Fabricate(:user)
      visit root_path
      login_to_system(user)
      click_link "Contacts"
      find(".add-contact-button a").click
    end
  end
end