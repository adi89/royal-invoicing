class BillingDocsController < ApplicationController

  def index
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