class ContactsController < ApplicationController

  def index
    @contacts = Kaminari.paginate_array(Contact.group_contacts(current_user.group)).page(params[:page]).per(6)
    @top_contacts = Contact.top_contacts(current_user)
  end

  def new
    @contact = Contact.new
    @contact.build_company
    if request.xhr?
      render layout: false
    end
  end

  def add_contact_to_estimate
    if request.xhr?
      @contact = Contact.new
      @contact.build_company
      render :add_contact_to_estimate, content_type: "text/html", layout: false
    end
  end


  def save_contact_to_estimate
    if request.xhr?
      @contact = Contact.new(contacts_params)
      if @contact.save
        current_user.contacts << @contact
        @contacts = current_user.contacts
        @invoice = Invoice.new
        render :save_contact_to_estimate, content_type: "text/html", layout: false
      else
        render nothing: true
      end
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

  def update
    if request.xhr?
      contact = Contact.find(params["id"])
      contact[params[:contact].keys.first] = params[:contact].values.first
      contact.save
      render :text => params[:contact].values.first
    else
      @contact = Contact.find(params[:id])
      company_name = contacts_params[:company_attributes][:name]
      update_params = contacts_params
      update_params.delete(:company_attributes)
      if @contact.update_attributes(update_params)
        @contact.company = Company.find_or_create_by_name(company_name)
        flash[:notice] = "#{@contact.name} updated successfully!"
        redirect_to(group_contacts_path(current_user.group))
      else
        flash[:notice] = "Something went wrong: #{@contact.errors.full_messages}"
        render :edit
      end
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def edit
    if request.xhr?
      @contact = Contact.find(params[:id])
      render :edit, layout: false
    else
      @contact = Contact.find(params[:id])
    end
  end

  def create
    @contact = Contact.new(contacts_params)
    if @contact.save
      current_user.contacts << @contact if @contact.valid?
    end
  end

  private
  def contacts_params
    params.require(:contact).permit(:name, :email, :job_title, :address, :twitter_handle, :phone_number, :website, :photo, company_attributes: [:name])
  end
end