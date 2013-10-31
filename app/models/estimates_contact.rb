# == Schema Information
#
# Table name: estimates_contacts
#
#  id          :integer          not null, primary key
#  estimate_id :integer
#  contact_id  :integer
#

class EstimatesContact < ActiveRecord::Base
 belongs_to :estimate
 belongs_to :contact
end
