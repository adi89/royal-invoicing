class ContactsController < ApplicationController

  def index
    @contacts = Contact.all
  end

  def new
    @contact = Contact.new
    @contact.build_company
    if request.xhr?
      render layout: false
    end
  end

  def company_ajax
    @existing_contact = Contact.find(params["data"]["contact-id"])
    @new_contact = Contact.new
    @new_contact.build_company
    render :_contact_company_form, content_type: "text/html", layout: false
  end

  def save_company_data
    @contact = Contact.find(params["contact_id"])
    @contact.company = Company.find(params["contact"]["company_attributes"]["id"])
    @contact.save
    render :text => @contact.company
  end

  def update
    if request.xhr?
      contact = Contact.find(params["id"])
      attribute = params[:contact].keys.first
      contact[attribute] = params[:contact].values.first
      contact.save
      render :text => params[:contact].values.first
    end
  end

  def show
    @contact = Contact.find(params[:id])
    @company = @contact.company
  end

  def edit
    if request.xhr?
      @contact = Contact.find(params[:id])
      render :new, layout: false
    end
  end

  def create
    if remotipart_submitted?
      binding.pry
      @contact = Contact.create(contacts_params)
      current_user.contacts << @contact if @contact.valid?
       # render :added_contact, layout: false, content_type: 'text/html'
    end
  end


  private
  def contacts_params
    params.require(:contact).permit(:name, :email, :job_title, :address, :twitter_handle, :phone_number, :website, :photo, company_attributes: [:name])
  end
end

