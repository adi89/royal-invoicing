class EstimatesController < ApplicationController
def index
    @invoices = Invoice.order(:due_date).page(params[:page]).per(5).where(kind: 'estimate').where("total IS NOT NULL")
  end

  def sort
    if request.xhr?
      @invoices = params["data"]["ids"].map{|i| Invoice.find(i)}
      attribute = params["data"]["type"]
      category = params["data"]["category"] == "invoices" ? @invoices : @estimates
      forward = params['data']['forward']
      instance_variable_set("@#{params['data']['category']}", Invoice.attribute_sort(attribute, category, forward))
      if params["data"]["category"] == "invoices"
        render :_sort_invoice, content_type: "text/html", layout: false
      else
        render :_estimate_table, content_type: "text/html", layout: false
      end
    end
  end

  def new
    @invoice = Invoice.new
    @kind = params["kind"]
    @invoice.line_items.build
    @contacts = current_user.contacts
    @invoices_contacts = @invoice.contacts.build
  end

  def make_invoice
    binding.pry
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
      invoice  = Invoice.new(invoice_params)
      params["invoice"]["id"].shift #take out the first empty string
      params["invoice"]["id"].each do |i|
          invoice.contacts << Contact.find(i)
      end
      invoice.total = invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
      invoice.save
      redirect_to estimate_path(invoice)
    end
  end

  private
    def invoice_params
      params.require(:invoice).permit(:title, :note, :due_date, :kind, :contact_attributes => [:id, :name, :email], :line_items_attributes => [:quantity, :price, :note, :invoice_id],  :invoice_contacts_attributes => [:contact_id, :invoice_id])
    end


end