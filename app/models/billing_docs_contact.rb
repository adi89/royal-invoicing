class BillingDocsContact < ActiveRecord::Base
  # self.primary_key = [:billing_doc_id, :contact_id]
 belongs_to :billing_doc
 belongs_to :contact
end