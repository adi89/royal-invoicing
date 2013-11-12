class CompaniesController < ApplicationController

  def add_company
    @existing_contact_id = params["data"]["contact-id"]
    @new_contact = Contact.new
    @new_contact.build_company
    render :add_company, content_type: "text/html", layout: false
  end

  def save_company_data
    @contact = Contact.find(params["contact_id"])
    @contact.company = Company.find(params["contact"]["company_attributes"]["id"])
    @contact.save
    render :json => @contact.company
  end

  def update
    if request.xhr?
      render :text => params[:company].values.first
    end
  end
end