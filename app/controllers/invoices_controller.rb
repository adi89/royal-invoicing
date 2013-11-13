class InvoicesController < ApplicationController

  def index
    @invoices = Kaminari.paginate_array(BillingDoc.group_invoices(current_user.group, 'invoice')).page(params[:page]).per(6)
  end

  def sort
    if request.xhr?
      @invoices = BillingDoc.where("id IN (#{params["ids"]})")
      attribute = params["type"]
      category = params["category"] == "invoices" ? @invoices : @estimates
      forward = params['forward']
      instance_variable_set("@#{params['category']}", BillingDoc.attribute_sort(attribute, category, forward))
      render :sort_invoice, content_type: "text/html", layout: false
    end
  end

  def new
    @invoice = BillingDoc.new
    @invoice.line_items.build
    @invoices_contacts = @invoice.contacts.build
    @contacts = Contact.group_contacts(current_user.group)
  end

  def edit
    @invoice = BillingDoc.find(params[:id])
    @invoices_contacts = @invoice.contacts.build
    @contacts = Contact.group_contacts(current_user.group)
  end

  def update
    @invoice = BillingDoc.find(params[:id])
    flash[:notice] = "Successfully updated #{@invoice.title.capitalize}" if @invoice.title
    @invoice.update(billing_doc_params)
    @invoice.contacts.delete_all
    params["billing_doc"]["id"].shift #take out the first empty string
    params["billing_doc"]["id"].each do |i|
      @invoice.contacts << Contact.find(i)
    end
    @invoice.line_items.delete_all
    billing_doc_params["line_items_attributes"].values.select{|i| i if !i.empty?}.each do |i|
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
    @invoice = BillingDoc.find(params['id'])
    if request.xhr?
      InvoicesPostEmailersWorker.perform_async(@invoice.id, {:user_id => current_user.id})
    end
  end

  def create
    @invoice  = BillingDoc.new(billing_doc_params)
    params["billing_doc"]["id"].shift #take out the first empty string
    params["billing_doc"]["id"].each do |i|
      @invoice.contacts << Contact.find(i)
    end
    @invoice.total = @invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
    if @invoice.save
      current_user.billing_docs << @invoice
      redirect_to group_invoice_path(current_user.group.id, @invoice)
    else
      flash[:notice]= "#{@invoice.errors.full_messages.first}"
      @contacts = Contact.group_contacts(current_user.group)
      render :new
    end
  end

  def pay
    invoice = BillingDoc.find(params["data"]["invoice-id"])
    invoice.pay
    render nothing: true, layout: false
  end

  private
  def billing_doc_params
    params.require(:billing_doc).permit(:title, :note, :due_date, :kind, :contact_attributes => [:id, :name, :email], :line_items_attributes => [:quantity, :price, :note, :billing_doc_id],  :billing_doc_contacts_attributes => [:contact_id, :billing_doc_id])
  end
end