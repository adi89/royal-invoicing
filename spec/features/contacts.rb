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
  describe "POST groups/:id/contact" do
    it 'should post and create a new contact', js: true do
      user = Fabricate(:user)
      visit root_path
      login_to_system(user)
      click_link "Manage Contacts"
      click_link "Create Contact"
      fill_in("name", with: "Adi")
      fill_in("email", with: "adityasingh89@gmail.com")
      fill_in("company name", with: "subvrt")
      click_button "Add Contact"
      page.should have_content "You sucessfully added"
    end
  end
  describe "Show groups/:id/contacts/:contact_id" do
      before(:each) do
        @user = Fabricate(:user)
        @contact = Fabricate(:contact)
        @contact2 = Contact.new(name: "john", email: "john@hotmail.com")
        @AAA = Company.create(name: "AAA")
        @contact2.company = @AAA
        @contact2.save
        @user.group.contacts << [@contact, @contact2]
        visit root_path
        login_to_system(@user)
        click_link "Manage Contacts"
      end
    it 'should render the show page', js: true do
      click_link "#{@contact.name}"
      page.should have_link "See All Contacts"
    end
    it 'should change the contact and update its company', js: true do
      click_link "#{@contact.name}"
      click_link "contact-company-show-link"
      page.find_by_id('contact_company_attributes_id').find("option[value='2']").select_option
      click_button "Save Company Data"
      page.should have_css('#contact-company-show-link', :text == "#{@AAA.name}")
    end
    it 'updates show fields in line', js: true do
      click_link "#{@contact.name}"
      find("#best_in_place_contact_1_phone_number").click
      find(:css, ".form_in_place input").set("7322219221")
      find("#contact-name").click
      page.should have_content "7322219221"
      visit(current_path)
      page.should have_content "7322219221"
    end
    it 'should edit and update the contact', js: true do
      click_link "#{@contact.name}"
      click_link "edit"
      sherman_path = Rails.root + 'app/assets/images/sherman.jpg'
      attach_file('contact_photo', sherman_path)
      click_button "Edit Contact"
      page.should have_content "updated successfully!"
    end
    it 'sorts the contacts by company names', js: true do
      find(".contact-item-row:first-child").should have_content "#{@contact.company.name}"
      click_link "Company"
      find(".contact-item-row:first-child").should have_content "#{@contact2.company.name}"
    end
  end
end