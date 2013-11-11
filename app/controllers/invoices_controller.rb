class InvoicesController < ApplicationController

  def index
    # @invoices = Invoice.order(:due_date).page(params[:page]).per(6).where(kind: 'invoice').where("total IS NOT NULL")
    @invoices = Kaminari.paginate_array(current_user.group.invoices('invoice')).page(params[:page]).per(6)
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
    @kind = 'invoice'
    @group = current_user.group
    @invoice.line_items.build
    @contacts = current_user.contacts
    @invoices_contacts = @invoice.contacts.build
  end

  def edit
    @invoice = Invoice.find(params[:id])
    @group = current_user.group
    @kind = @invoice.kind
    @invoices_contacts = @invoice.contacts.build
    @contacts = current_user.contacts
    render 'invoices/new'
  end


  def update
    invoice = Invoice.find(params[:id])
    flash[:notice] = "Successfully updated #{invoice.title.capitalize}"
    invoice.update(invoice_params)
    invoice.contacts.delete_all
    binding.pry
    params["invoice"]["id"].shift #take out the first empty string
    params["invoice"]["id"].each do |i|
      invoice.contacts << Contact.find(i)
    end
    invoice.line_items.delete_all
    invoice_params["line_items_attributes"].values.select{|i| i if !i.empty?}.each do |i|
      invoice.line_items << LineItem.create(i)
    end
    invoice.total = invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
    if invoice.save
      binding.pry
      if invoice.kind == "invoice"
        redirect_to(group_invoice_path(current_user.group.id, invoice))
      else
        redirect_to(group_estimate_path(current_user.group.id, invoice))
      end
    else
      render :new
    end
  end

  def show
    @invoice = Invoice.find(params['id'])
    if request.xhr?
      InvoicesPostEmailersWorker.perform_async(@invoice.id, {:user_id => current_user.id})
    end
  end

  # def see_all
  #   if request.xhr?
  #     invoices_array = Invoice.where(kind: "invoice").where("total IS NOT NULL").sort_by(&:due_date).map{|i| i.id}
  #     @invoice_ids = params["data"]["invoice_ids"].map{|i| i.to_i}
  #     @invoice_ids.each do |i|
  #       if invoices_array.include? i
  #         invoices_array.delete(i)
  #       end
  #     end
  #     @invoices = invoices_array.map{|i| Invoice.find(i)}
  #     binding.pry
  #     render :_invoice_table, content_type: "text/html", layout: false
  #   end
  # end

  def create
    binding.pry
    invoice  = Invoice.new(invoice_params)
    params["invoice"]["id"].shift #take out the first empty string
    params["invoice"]["id"].each do |i|
      invoice.contacts << Contact.find(i)
    end
    invoice.total = invoice.line_items.map{|i| i.price * i.quantity}.reduce(:+)
    invoice.save
    current_user.invoices << invoice
    redirect_to group_invoice_path(current_user.group.id, invoice)
  end

  def paid_invoice
    invoice = Invoice.find(params["data"]["invoice-id"])
    invoice.pay
    render  nothing: true, layout: false
  end

  private
  def invoice_params
    params.require(:invoice).permit(:title, :note, :due_date, :kind, :contact_attributes => [:id, :name, :email], :line_items_attributes => [:quantity, :price, :note, :invoice_id],  :invoice_contacts_attributes => [:contact_id, :invoice_id])
  end
end