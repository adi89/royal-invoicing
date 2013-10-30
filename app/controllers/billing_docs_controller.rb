class BillingDocsController < ApplicationController

  def index
    @billing_docs = BillingDoc.order(:due_date).page(params[:page]).per(5).where("total IS NOT NULL")
  end

  def sort
    if request.xhr?
      @billing_docs = params["data"]["ids"].map{|i| BillingDoc.find(i)}
      attribute = params["data"]["type"]
      category = params["data"]["category"] == "billing_docs" ? @billing_docs : @estimates
      forward = params['data']['forward']
      instance_variable_set("@#{params['data']['category']}", BillingDoc.attribute_sort(attribute, category, forward))
      if params["data"]["category"] == "billing_docs"
        render :_sort_invoice, content_type: "text/html", layout: false
      else
        render :_estimate_table, content_type: "text/html", layout: false
      end
    end
  end

  def new
    @billing_doc = BillingDoc.new
    @kind = params["kind"]
    # @billing_doc.build_contact
    @billing_doc.line_items.build
    @contacts = current_user.contacts
    @billing_docs_contacts = @billing_doc.contacts.build
  end

  def show
    @billing_doc = BillingDoc.find(params['id'])
    if request.xhr?
        InvoicesPostEmailersWorker.perform_async(@billing_doc.id, {:user_id => current_user.id})
    end
  end

  def see_all
    if request.xhr?
      invoices_array = BillingDoc.where(kind: "invoice").where("total IS NOT NULL").sort_by(&:due_date).map{|i| i.id}
      @billing_ids = params["data"]["invoice_ids"].map{|i| i.to_i}
      @billing_ids.each do |i|
        if invoices_array.include? i
          invoices_array.delete(i)
        end
    end
      @invoices = invoices_array.map{|i| BillingDoc.find(i)}
      render :_invoice_table, content_type: "text/html", layout: false
  end
end

  def create
    if request.xhr?
      contact_name = params["name"].downcase
      string = "name LIKE ? OR name LIKE?", "#{contact_name}", "#{contact_name.titleize}"
      @contact = Contact.where(string).first
        if @contact.present?
          render :contact_addition, content_type: 'text/html', layout: false
        else
          render nothing: true
        end
    else
      billing_doc  = BillingDoc.new(billing_doc_params)
      params["billing_doc"]["id"].shift #take out the first empty string
      params["billing_doc"]["id"].each do |i|
          billing_doc.contacts << Contact.find(i)
      end
      billing_doc.total = billing_doc.line_items.map{|i| i.price * i.quantity}.reduce(:+)
      billing_doc.save
      redirect_to billing_doc_path(billing_doc)
    end
  end

  private
    def billing_doc_params
      params.require(:billing_doc).permit(:title, :note, :due_date, :kind, :contact_attributes => [:id, :name, :email], :line_items_attributes => [:quantity, :price, :note, :billing_doc_id],  :billing_docs_contacts_attributes => [:contact_id, :billing_doc_id])
    end

end