require 'spec_helper'
include Devise::TestHelpers
include ControllerMacros

describe CompaniesController do
  before(:each) do
    @contact = Fabricate(:contact)
  end

  describe 'save_company_ajax' do
    it 'saves company data action' do
      login_user(@contact.user)
      xhr :post, :create, {use_route: "save_company_data", "contact_id"=> @contact.id,

                                      "contact" => {"company_attributes" => {"id" => @contact.company.id }
                                                    }
                                      }
      expect(response.status).to eq (200)
    end
  end

  describe 'add_Company' do
    it 'does the company ajax action' do
      login_user(@contact.user)
      xhr :get, :new, {use_route: "add_company",
                      "contact-id" => "#{@contact.id}"}
      expect(response.status).to eq (200)
    end
  end

end