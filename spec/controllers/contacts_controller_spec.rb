require "spec_helper"
include Devise::TestHelpers
include ControllerMacros

describe ContactsController do
  before(:each) do
    @contact = Fabricate(:contact)
    @user = Fabricate(:user)
    @user.group.contacts << @contact
  end

  describe 'GET Index' do
    it "has a 200 status code" do
      login_user(@user)
      get :index, {group_id: @contact.group.id, use_route: "group_contacts"}
      expect(response.status).to eq(200)
    end
  end

  describe 'Show page' do
    it 'renders gives us the show page' do
      login_user(@user)
      get :show, {group_id: @contact.group.id, id: @contact.id, use_route: "group_contact"}
      expect(response.status).to eq(200)
      response.should render_template(:show)
    end
  end

  describe 'New invoice' do
    it 'renders the new page and has a 200 status ' do
      login_user(@user)
      get :new, {group_id: @contact.group.id, use_route: "new_contact_invoice"}
      expect(response.status).to eq (200)
      response.should render_template(:new)
    end
  end

  describe "sort" do
    it 'sorts the contacts successfully passing the sort action' do
      login_user(@user)
      xhr :get, :sort, {group_id: @contact.group.id, use_route: "sort_contact_invoices",
                        "type"=>"due_date",
                        "forward" => "false",
                        "ids" => "#{@contact.id}"
                        }
      expect(response.status).to eq (200)
    end
  end

  describe 'update' do
    it 'successfully updates the contact info in update action' do
      login_user(@user)
      patch :update, {use_route: "group_contact", :group_id => @contact.group.id, :id => @contact.id, "contact" =>
                      {"name"=>"Adi Singh",
                       "email"=>"adi_singh_is_king@hotmail.com",
                       "phone_number"=>"7324039102",
                       "company_attributes"=>{"name"=>"MMAdurp", "id"=>"#{@contact.company.id}"},
                       "job_title"=>"derp",
                       "address"=>"21 ridings parkway",
                       "twitter_handle"=>"@Jay_Dilla"},
                      "commit"=>"Edit Contact",
                      "action"=>"update",
                      "controller"=>"contacts"
                      }
      expect(response.status).to eq (302)
    end
  end

  describe 'ajax create' do
    it 'it follows contact action logic and redirects' do
      login_user(@user)
      xhr :post, :create, {use_route: :group_contacts, :group_id => @contact.group.id, "contact" =>
                           {"name"=>"blah ",
                            "email"=>"adi_singh_is_the_king@hotmail.com",
                            "phone_number"=>"7324039102",
                            "company_attributes"=>{"name"=>"adds"},
                            "job_title"=>"jobjob",
                            "address"=>"123 jay street",
                            "twitter_handle"=>"@Jay_Dilla"
                            }
                           }
      expect(response.status).to eq (200)
    end
  end

end