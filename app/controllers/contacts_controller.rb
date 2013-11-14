class ContactsController < ApplicationController

  def index
    @contacts = current_user.group.contacts.page(params[:page]).per(6)
    @top_contacts = Contact.top_contacts(current_user.group)
  end

  def new
    @contact = Contact.new
    @contact.build_company
    if (params['type'] == 'mini')
      return render :mini_contact_form, layout: false
    end
    if request.xhr?
      render layout: false
    end
  end

  def sort
    if request.xhr?
      @contacts = Contact.where("id IN (#{params["ids"]})")
      attribute = params["type"]
      forward = params['forward']
      if forward == "false"
        @contacts = @contacts.order('name desc')
      else
        @contacts = @contacts.order('name asc')
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
    if request.xhr?
      @contact = Contact.new(contacts_params)
      if params["type"] == "mini" #estimate form call
        if @contact.save
          current_user.group.contacts << @contact
          @contacts = current_user.group.contacts
          @invoice = BillingDoc.new
          render :contact_collection_select, content_type: "text/html", layout: false
        else
          render nothing: true
        end
      else #main modal
        if @contact.save
          current_user.group.contacts << @contact if @contact.valid?
        else
          flash[:notice] = "#{@invoice.errors.full_messages}"
          render :js => "window.location.href = '#{new_group_contact_path(current_user.group.id)}'"
        end
      end
    else
      redirect_to group_contacts_path(current_user.group.id)
    end
  end

  private
  def contacts_params
    params.require(:contact).permit(:name, :email, :job_title, :address, :twitter_handle, :phone_number, :website, :photo, company_attributes: [:name])
  end
end