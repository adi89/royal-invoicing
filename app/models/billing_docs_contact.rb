# == Schema Information
#
# Table name: invoices_contacts
#
#  id         :integer          not null, primary key
#  invoice_id :integer
#  contact_id :integer
#

class BillingDocsContact < ActiveRecord::Base
  belongs_to :billing_doc
  belongs_to :contact
end
