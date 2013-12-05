class BillingDocsController < ApplicationController

  def index
    @kind = params[:kind]
    binding.pry
    if request.xhr?
      if @kind == "invoice"
        @invoices = current_user.group.billing_docs.invoice.fuzzy_search(params['term'])
      else
        @invoices = current_user.group.billing_docs.estimate.fuzzy_search(params['term'])
      end
      render partial: 'index_table', layout: false
      #do this
    else
      if params[:kind] == "invoice"
        # current_user.group.billing_docs.invoice
        @invoices = current_user.group.billing_docs.invoice.page(params[:page]).per(6)
      else
        @invoices = current_user.group.billing_docs.estimate.page(params[:page]).per(6)
      end
    end
  end

  def sort
    if request.xhr?
      forward = params['forward']
      attribute = params["type"]
      if params['category'] == 'invoices'
        @invoices = current_user.group.billing_docs.invoice.attribute_sort(attribute, forward)
      else
        @invoices = current_user.group.billing_docs.estimate.attribute_sort(attribute, forward)
      end
      render :sort_invoice, content_type: "text/html", layout: false
    end
  end

  def new
    @invoice = BillingDoc.new()
    @invoice.line_items.build
    @invoices_contacts = @invoice.contacts.build
    @contacts = current_user.group.contacts
    if params[:kind] == "invoice"
      render 'new_invoice'
    else
      render 'new_estimate'
    end
  end

  def edit
    @invoice = BillingDoc.find(params[:id])
    @invoices_contacts = @invoice.contacts.build
    @contacts = current_user.group.contacts
    if @invoice.kind == 'invoice'
      render 'edit_invoice'
    else
      render 'edit_estimate'
    end
  end

  def make_into_invoice
    estimate = BillingDoc.find(params["data"]["estimate-id"])
    estimate.convert_to_invoice
    render  nothing: true, layout: false
  end


  def update
    @invoice = BillingDoc.find(params[:id])
    flash[:notice] = "Successfully updated #{@invoice.title.capitalize}" if @invoice.title
    @invoice.update(billing_doc_params)
    @invoice.contacts.delete_all
    params['invoice']["id"].select!{|i| i if i.present?} #take out the first empty string
    params["invoice"]["id"].each do |i|
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
        redirect_to(group_billing_docs_kind_path(current_user.group.id, @invoice.kind))
      else
        redirect_to(group_billing_docs_kind_path(current_user.group.id, @invoice.kind))
      end
    else
      @invoices_contacts = @invoice.contacts.build
      @contacts = Contact.group_contacts(current_user.group)
      if @invoice.kind == 'invoice'
        render 'edit_invoice'
      else
        render 'edit_estimate'
      end
    end
  end

  def show
    @invoice = BillingDoc.find(params['id'])
    if request.xhr?
      InvoicesMailerEmailersWorker.perform_async(@invoice.id, {:user_id => current_user.id})
    end
  end

  def create
    @invoice  = BillingDoc.new(billing_doc_params)
    params['invoice']["id"].select!{|i| i if i.present?} #take out the empty strings
    params['invoice']["id"].each do |i|
      @invoice.contacts << Contact.find(i)
    end
    @invoice.total = @invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
    if @invoice.save
      current_user.group.billing_docs << @invoice
      redirect_to group_billing_doc_path(current_user.group.id, @invoice)
    else
      flash[:notice]= "#{@invoice.errors.full_messages.first}"
      @contacts = Contact.group_contacts(current_user.group)
      if @invoice.kind == 'invoice'
        render 'new_invoice'
      else
        render 'new_estimate'
      end
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