require 'spec_helper'
include Devise::TestHelpers
include ControllerMacros

describe CompaniesController do
  before(:each) do
    @contact = Fabricate(:contact)
    @user = User.create(email: "dirknowitski@gmail.com", password:"akansha1")
    @contact.group.users << @user
  end

  describe 'create' do
    it 'saves company data action' do
      login_user(@user)
      xhr :post, :create, {use_route: "save_company_data", "contact_id"=> @contact.id,

                                      "contact" => {"company_attributes" => {"id" => @contact.company.id }
                                                    }
                                      }
      expect(response.status).to eq (200)
    end
  end

  describe 'new' do
    it 'does the company ajax action' do
      login_user(@user)
      xhr :get, :new, {use_route: "add_company",
                      "contact-id" => "#{@contact.id}"}
      expect(response.status).to eq (200)
    end
  end

end