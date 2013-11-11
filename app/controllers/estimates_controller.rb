class EstimatesController < ApplicationController

  def index
    @invoices = Kaminari.paginate_array(current_user.group.invoices('estimate')).page(params[:page]).per(6)
  end

  def sort
    if request.xhr?
      binding.pry
      @invoices = params["ids"].split(',').map{|i| Invoice.find(i)}
      attribute = params["type"]
      category = params["category"] == "invoices" ? @invoices : @estimates
      forward = params['forward']
      instance_variable_set("@#{params['category']}", Invoice.attribute_sort(attribute, category, forward))
        render :sort_invoice, content_type: "text/html", layout: false
      end
  end

  def add_contact
    if request.xhr?
      @contact = Contact.new
      @contact.build_company
      @group = current_user.group
      render :add_contact, content_type: "text/html", layout: false
    end
  end

  def save_contact
    if request.xhr?
      @contact = Contact.new(contacts_params)
      if @contact.save
        current_user.contacts << @contact
        @contacts = current_user.contacts
        @invoice = Invoice.new
        render :_save_contact, content_type: "text/html", layout: false
      else
        render nothing: true
      end
    end
  end


  def new
    @invoice = Invoice.new
    @kind = 'estimate'
    @group = current_user.group
    @invoice.line_items.build
    @contacts = current_user.contacts
    @invoices_contacts = @invoice.contacts.build
  end

  def edit
    @invoice = Invoice.find(params[:id])
    @kind = @invoice.kind
    @group = current_user.group
    @invoices_contacts = @invoice.contacts.build
    @contacts = current_user.contacts
    render :new
  end

  def make_invoice
    estimate = Invoice.find(params["data"]["estimate-id"])
    estimate.invoice
    #make invoice
    render  nothing: true, layout: false
  end


  def show
    @invoice = Invoice.find(params['id'])
    if request.xhr?
      InvoicesPostEmailersWorker.perform_async(@invoice.id, {:user_id => current_user.id})
    end
  end

  def see_all
    if request.xhr?
      invoices_array = Invoice.where(kind: "invoice").where("total IS NOT NULL").sort_by(&:due_date).map{|i| i.id}
      @invoice_ids = params["data"]["invoice_ids"].map{|i| i.to_i}
      @invoice_ids.each do |i|
        if invoices_array.include? i
          invoices_array.delete(i)
        end
      end
      @invoices = invoices_array.map{|i| Invoice.find(i)}
      render :_invoice_table, content_type: "text/html", layout: false
    end
  end

  def create
    invoice  = Invoice.new(invoice_params)
    params["invoice"]["id"].select!{|i| !i.blank?} #take out any empty strings
    params["invoice"]["id"].each do |i|
      invoice.contacts << Contact.find(i)
    end
    invoice.total = invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
    if invoice.save
      current_user.invoices << invoice
      render :js => "window.location.href = '#{group_estimate_path(current_user.group.id, invoice.id)}'"
    else
      render :new
    end
  end

  private
  def invoice_params
    params.require(:invoice).permit(:title, :note, :due_date, :kind, :contact_attributes => [:id, :name, :email], :line_items_attributes => [:quantity, :price, :note, :invoice_id],  :invoice_contacts_attributes => [:contact_id, :invoice_id])
  end
  def contacts_params
    params.require(:contact).permit(:name, :email, company_attributes: [:name])
  end


end