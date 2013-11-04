class ContactsController < ApplicationController
  def index
    @contacts = Contact.order(:name).page(params[:page]).per(3)
    @top_contacts = Contact.top_contacts
  end

  def new
    @contact = Contact.new
    @contact.build_company
    if request.xhr?
      render layout: false
    end
  end

  def sort
    if request.xhr?
      @contacts = params["data"]["ids"].map{|i| Contact.find(i)}
      attribute = params["data"]["type"]
      forward = params['data']['forward']
      if forward == "false"
        @contacts = @contacts.sort_by{|i| i.company.name}.reverse
      else
        @contacts = @contacts.sort_by{|i| i.company.name}
      end
      render :_sort_contact, content_type: "text/html", layout: false
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
    render :json => @contact.company
  end

  def update
    if request.xhr?
      if params[:_method] == "patch"
        @contact = Contact.find(params[:id])
        @contact.update_attributes(contacts_params)
        @company = @contact.company
        render :js => "window.location = '/contacts/#{@contact.id}'"
      else
        contact = Contact.find(params["id"])
        attribute = params[:contact].keys.first
        contact[attribute] = params[:contact].values.first
        contact.save
        render :text => params[:contact].values.first
      end
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
    else
      @contact = Contact.find(params[:id])
      @photo = @contact.photo.to_s
      @contact.build_company
      render :new
    end
  end


  def create
    @contact = Contact.new(contacts_params)
      if @contact.save
        current_user.contacts << @contact if @contact.valid?
      else
        @errors = @contact.errors.full_messages
      end
  end


  private
  def contacts_params
    params.require(:contact).permit(:name, :email, :job_title, :address, :twitter_handle, :phone_number, :website, :photo, company_attributes: [:name])
  end
end