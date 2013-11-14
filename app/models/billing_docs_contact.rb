# == Schema Information
#
# Table name: billing_docs_contacts
#
#  id             :integer          not null, primary key
#  billing_doc_id :integer
#  contact_id     :integer
#

class BillingDocsContact < ActiveRecord::Base
  belongs_to :billing_doc
  belongs_to :contact
end
