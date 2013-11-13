class EstimatesController < ApplicationController

  def index
    @invoices = BillingDoc.group_invoices(current_user.group, 'estimate').page(params[:page]).per(6)
  end

  def sort
    if request.xhr?
      @invoices = params["ids"].split(',').map{|i| BillingDoc.find(i)}
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

  def make_into_invoice
    estimate = BillingDoc.find(params["data"]["estimate-id"])
    estimate.convert_to_invoice
    render  nothing: true, layout: false
  end

  def show
    @invoice = BillingDoc.find(params['id'])
    if request.xhr?
      BillingDocsPostEmailersWorker.perform_async(@invoice.id, {:user_id => current_user.id})
    end
  end

  def create
    @invoice  = BillingDoc.new(billing_doc_params)
    params["billing_doc"]["id"].select!{|i| !i.blank?} #take out any empty strings
    params["billing_doc"]["id"].each do |i|
      @invoice.contacts << Contact.find(i)
    end
    @invoice.total = @invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
    if @invoice.save
      current_user.billing_docs << @invoice
      render :js => "window.location.href = '#{group_estimate_path(current_user.group.id, @invoice.id)}'"
    else
      flash[:notice]= "#{@invoice.errors.full_messages.first}"
      @contacts = Contact.group_contacts(current_user.group)
      render :new
    end
  end

  private
  def billing_doc_params
    params.require(:billing_doc).permit(:title, :note, :due_date, :kind, :contact_attributes => [:id, :name, :email], :line_items_attributes => [:quantity, :price, :note, :billing_doc_id],  :billing_doc_contacts_attributes => [:contact_id, :billing_doc_id])
  end
end