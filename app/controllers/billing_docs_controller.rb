class BillingDocsController < ApplicationController

  def index
  end

  def new
    @billing_doc = BillingDoc.new
    @kind = params["kind"]
    @billing_doc.build_contact
    @billing_doc.line_items.build

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
      binding.pry
      BillingDoc.create(billing_doc_params)
    end
  end

  private
    def billing_doc_params
      permit(:billing_doc).permit(:title, :note, :due_date, :kind, :contact_attributes => [:id, :name, :email], :line_items_attributes => [:quantity, :price, :note, :billing_doc_id])
    end

end