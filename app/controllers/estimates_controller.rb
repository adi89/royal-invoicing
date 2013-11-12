class EstimatesController < ApplicationController

  def index
    @invoices = Kaminari.paginate_array(Invoice.group_invoices(current_user.group, 'estimate')).page(params[:page]).per(6)
  end

  def sort
    if request.xhr?
      @invoices = params["ids"].split(',').map{|i| Invoice.find(i)}
      attribute = params["type"]
      category = params["category"] == "invoices" ? @invoices : @estimates
      forward = params['forward']
      instance_variable_set("@#{params['category']}", Invoice.attribute_sort(attribute, category, forward))
        render :sort_invoice, content_type: "text/html", layout: false
      end
  end

  def new
    @invoice = Invoice.new
    @invoice.line_items.build
    @invoices_contacts = @invoice.contacts.build
    @contacts = Contact.group_contacts(current_user.group)
  end

  def edit
    @invoice = Invoice.find(params[:id])
    @invoices_contacts = @invoice.contacts.build
    @contacts = Contact.group_contacts(current_user.group)
  end

  def make_into_invoice
    estimate = Invoice.find(params["data"]["estimate-id"])
    estimate.convert_to_invoice
    render  nothing: true, layout: false
  end

  def show
    @invoice = Invoice.find(params['id'])
    if request.xhr?
      InvoicesPostEmailersWorker.perform_async(@invoice.id, {:user_id => current_user.id})
    end
  end

  def create
    @invoice  = Invoice.new(invoice_params)
    params["invoice"]["id"].select!{|i| !i.blank?} #take out any empty strings
    params["invoice"]["id"].each do |i|
      @invoice.contacts << Contact.find(i)
    end
    @invoice.total = invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
    if @invoice.save
      current_user.invoices << @invoice
      render :js => "window.location.href = '#{group_estimate_path(current_user.group.id, @invoice.id)}'"
    else
      flash[:notice]= "#{@invoice.errors.full_messages.first}"
      @contacts = Contact.group_contacts(current_user.group)
      render :new
    end
  end

  private
  def invoice_params
    params.require(:invoice).permit(:title, :note, :due_date, :kind, :contact_attributes => [:id, :name, :email], :line_items_attributes => [:quantity, :price, :note, :invoice_id],  :invoice_contacts_attributes => [:contact_id, :invoice_id])
  end
end