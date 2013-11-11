# == Schema Information
#
# Table name: invoices_users
#
#  id         :integer          not null, primary key
#  invoice_id :integer
#  user_id    :integer
#

class InvoicesUser < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :user
end
