class InvoicesController < ApplicationController

  def index
    @invoices = Kaminari.paginate_array(Invoice.group_invoices(current_user.group, 'invoice')).page(params[:page]).per(6)
  end

  def sort
    if request.xhr?
      @invoices = Invoice.where("id IN (#{params["ids"]})")
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

  def update
    @invoice = Invoice.find(params[:id])
    flash[:notice] = "Successfully updated #{@invoice.title.capitalize}"
    @invoice.update(invoice_params)
    @invoice.contacts.delete_all
    params["invoice"]["id"].shift #take out the first empty string
    params["invoice"]["id"].each do |i|
      @invoice.contacts << Contact.find(i)
    end
    @invoice.line_items.delete_all
    invoice_params["line_items_attributes"].values.select{|i| i if !i.empty?}.each do |i|
      @invoice.line_items << LineItem.create(i)
    end
    @invoice.total = @invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
    if @invoice.save
      if @invoice.kind == "invoice"
        flash[:notice] = "#{@invoice.title} updated successfully!"
        redirect_to(group_invoices_path(current_user.group.id))
      else
        redirect_to(group_estimate_path(current_user.group.id, @invoice))
      end
    else
      @invoices_contacts = @invoice.contacts.build
      @contacts = Contact.group_contacts(current_user.group)
      render :edit
    end
  end

  def show
    @invoice = Invoice.find(params['id'])
    if request.xhr?
      InvoicesPostEmailersWorker.perform_async(@invoice.id, {:user_id => current_user.id})
    end
  end

  def create
    @invoice  = Invoice.new(invoice_params)
    params["invoice"]["id"].shift #take out the first empty string
    params["invoice"]["id"].each do |i|
      @invoice.contacts << Contact.find(i)
    end
    @invoice.total = @invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
    if @invoice.save
      current_user.invoices << @invoice
      redirect_to group_invoice_path(current_user.group.id, @invoice)
    else
      flash[:notice]= "#{@invoice.errors.full_messages.first}"
      @contacts = Contact.group_contacts(current_user.group)
      render :new
    end
  end

  def pay
    invoice = Invoice.find(params["data"]["invoice-id"])
    invoice.pay
    render nothing: true, layout: false
  end

  private
  def invoice_params
    params.require(:invoice).permit(:title, :note, :due_date, :kind, :contact_attributes => [:id, :name, :email], :line_items_attributes => [:quantity, :price, :note, :invoice_id],  :invoice_contacts_attributes => [:contact_id, :invoice_id])
  end
end