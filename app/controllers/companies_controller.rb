class CompaniesController < ApplicationController

  def new
    if request.xhr?
      @existing_contact_id = params["contact-id"]
      @new_contact = Contact.new
      @new_contact.build_company
      render content_type: "text/html", layout: false
    else
      redirect_to(group_contact_path(current_user.group, @existing_contact_id))
    end
  end

  def create
    if request.xhr?
      @contact = Contact.find(params["contact_id"])
      company = Company.find(params["contact"]["company_attributes"]["id"])
      company.contacts << @contact
      if company.save
        render :json => company
      end
    else
      redirect_to(group_contact_path(current_user.group, @contact))
    end
  end
end