# == Schema Information
#
# Table name: invoices_users
#
#  id         :integer          not null, primary key
#  invoice_id :integer
#  user_id    :integer
#

class BillingDocsUser < ActiveRecord::Base
  belongs_to :billing_doc
  belongs_to :user
end
