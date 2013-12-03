require "spec_helper"
require 'features/shared/login_helper'
include LoginHelper

describe 'Registrations' do

  describe 'Get /' do
    it 'displays a sign in link', :js => true do
      visit root_path
      page.should have_link('Sign In')
    end
  end

  describe 'get /login' do
    it 'shows Sign in page', :js => true do
      visit root_path
      click_link("Sign In")
      page.should have_content('Sign in')
    end
  end
  describe 'POST /login' do
    it ' logs the user into the system if the credentials are correct', :js => true do
      user = Fabricate(:user)
      visit root_path
      login_to_system(user)
      page.should have_content('Signed in successfully.')
      page.should have_link "Invoices"
      page.should have_link "Estimates"
    end
  end
  describe 'DELETE /login' do
    it 'logs the user off', js: true do
      user = Fabricate(:user)
      visit root_path
      login_to_system(user)
      page.should have_link(user.email)
      click_link(user.email)
      click_link("Sign Out")
      page.should_not have_link(user.email)
    end
  end
end