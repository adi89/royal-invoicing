require "spec_helper"
include Devise::TestHelpers
include ControllerMacros

describe BillingDocsController do
  before(:each) do
    @invoice = Fabricate(:billing_doc)
    @user = Fabricate(:user)
    @group = @user.group
    @invoice.line_items << LineItem.create(price: 20, quantity: 20, note: 'none')
  end

  describe 'GET Index' do
    it "has a 200 status code" do
      login_user(@user)
      get :index, {group_id: @user.group.id, use_route: "group_invoices"}
      expect(response.status).to eq(200)
    end
  end

  describe 'Show page' do
    it 'renders gives us the show page' do
      login_user(@user)
      get :show, {group_id: @user.group.id, id: @invoice.id, use_route: "group_invoice"}
      expect(response.status).to eq(200)
      response.should render_template(:show)
    end
  end

  describe 'New invoice' do
    it 'renders the new page and has a 200 status ' do
      login_user(@user)
      get :new, {group_id: @user.group.id, use_route: "new_group_invoice", kind: 'invoice'}
      expect(response.status).to eq (200)
      response.should render_template(:new_invoice)
    end
  end

  describe 'sort' do
    it 'gives us the sort ajax req' do
      login_user(@user)
      @group.billing_docs << @invoice
      xhr :get, :sort, {group_id: @user.group.id, use_route: "sort_group_invoices",
                        "type"=>"due_date",
                        "category" => "invoices",
                        "forward" => "asc",
                        "ids" => "#{@group.billing_docs.map{|i| i.id}}"
                        }
      expect(response.status).to eq (200)
    end
  end

  describe 'edit' do
    it 'gives us a 200 for edit' do
      login_user(@user)
      get :edit, {group_id: @user.group.id, id: @invoice.id, use_route: "edit_group_invoice"}
      expect(response.status).to eq (200)
      response.should render_template(:edit_invoice)
    end
  end

  describe 'update' do
    it 'successfully edits invoice' do
      login_user(@user)
      company = Fabricate(:company)
      @invoice.contacts << Contact.create(name: 'joe', email: 'joeschmoe21@gmail.com', company_id: company.id)
      patch :update, {group_id: @user.group.id, id: @invoice.id, use_route: "patch_group_invoice",
                      "_method"=>"patch",
                      "billing_doc"=>
                      {"title"=>"dsfadsdasds",
                       "note"=>"fdasdds",
                       "due_date"=>"11/13/2013",
                       "id"=> ["", @invoice.contacts.first.id],
                       "kind"=>"invoice",
                       "line_items_attributes"=> {"0" => {"note"=> @invoice.line_items.first.note, "quantity"=> 20, "price"=>"32.32", "id"=> @invoice.line_items.first.id}}},
                        "invoice" => {"id" => ["", "#{@invoice.contacts.first.id}"]},
                      "total"=> "300",
                      "commit"=>"Create BillingDoc",
                      }
      expect(response.status).to eq(302)
      #redirect occurs
    end
  end

  describe 'paid' do
    it 'brings you to paid action form js' do
      login_user(@user)
      xhr :post, :pay, {use_route: "pay", "data" => {"invoice-id"=> @invoice.id}}
      expect(response.status).to eq 200
    end
  end

  describe 'create' do
    it 'creates an invoice#action' do
      company = Fabricate(:company)
      @invoice.contacts << Contact.create(name: 'joe', email: 'joeschmoe21@gmail.com', company_id: company.id)
      login_user(@user)
      post :create, {use_route: "group_invoices", group_id: @user.group.id,
                     "billing_doc"=>
                     {"title"=>"darkemosynthppop",
                      "note"=>"derp",
                      "due_date"=>"11/29/2013",
                      "kind"=>"invoice",
                      "id"=>["", "#{@invoice.contacts.first.id}"],
                      "line_items_attributes"=>
                      {"0"=>{"note"=>"fdsd", "quantity"=>"33", "price"=>"32.32"}}},
                      "invoice" => {"id" => ["", "#{@invoice.contacts.first.id}"]}
                     }
      expect(response.status).to eq (302)
    end
  end

end