# == Schema Information
#
# Table name: invoices_contacts
#
#  id         :integer          not null, primary key
#  invoice_id :integer
#  contact_id :integer
#

class InvoicesContact < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :contact
end
