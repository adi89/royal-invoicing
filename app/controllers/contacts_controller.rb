class ContactsController < ApplicationController
  def index
    @contacts = Kaminari.paginate_array(current_user.group.users.includes(:contacts).map{|i| i.contacts}.flatten).page(params[:page]).per(6)

    @top_contacts = Contact.top_contacts(current_user)
  end

  def new
    @contact = Contact.new
    @group = current_user.group
    @contact.build_company
    if request.xhr?
      render layout: false
    end
  end

  def sort
    if request.xhr?
      @contacts = params["ids"].split(',').map{|i| Contact.find(i)}
      attribute = params["type"]
      forward = params['forward']
      if forward == "false"
        @contacts = @contacts.sort_by{|i| i.company.name}.reverse
      else
        @contacts = @contacts.sort_by{|i| i.company.name}
      end
      render :sort_contact, content_type: "text/html", layout: false
    end
  end


  def company_ajax
    @existing_contact = Contact.find(params["data"]["contact-id"])
    @new_contact = Contact.new
    @group = current_user.group
    @new_contact.build_company
    render :contact_company_form, content_type: "text/html", layout: false
  end

  def save_company_data
    @contact = Contact.find(params["contact_id"])
    @contact.company = Company.find(params["contact"]["company_attributes"]["id"])
    @contact.save
    render :json => @contact.company
  end

  def update
    if request.xhr?
      contact = Contact.find(params["id"])
      attribute = params[:contact].keys.first
      contact[attribute] = params[:contact].values.first
      contact.save
      render :text => params[:contact].values.first
    else
     @contact = Contact.find(params[:id])
      company_name = contacts_params[:company_attributes][:name]
      update_params = contacts_params
      update_params.delete(:company_attributes)
      @contact.update_attributes(update_params)
      @contact.company = Company.find_or_create_by_name(company_name)
      @company = @contact.company
      @group = current_user.group
      render :show
    end
  end

  def show
    @contact = Contact.find(params[:id])
    @company = @contact.company
    @group = current_user.group
  end

  def edit
    if request.xhr?
      @contact = Contact.find(params[:id])
      @group = current_user.group
      render :new, layout: false
    else
      @contact = Contact.find(params[:id])
      @photo = @contact.photo.to_s
      @group = current_user.group
      render :edit
    end
  end


  def create
    binding.pry
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