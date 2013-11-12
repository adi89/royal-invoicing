# == Schema Information
#
# Table name: invoices
#
#  id         :integer          not null, primary key
#  total      :decimal(, )
#  note       :text
#  state      :string(255)
#  kind       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#  due_date   :string(255)
#

class Invoice < ActiveRecord::Base
  has_many :invoices_contacts
  has_many :contacts, through: :invoices_contacts
  has_many :line_items
  has_many :invoices_users
  has_many :users, through: :invoices_users

  accepts_nested_attributes_for :contacts
  accepts_nested_attributes_for :line_items

  state_machine :state, initial: :unpaid do
    event :pay do
      transition all => :paid
    end
    event :unpay do
      transition all => :unpaid
    end
  end

  state_machine :kind , initial: :pending do
    event :convert_to_invoice do
      transition all => :invoice
    end
    event :convert_to_estimate do
      transition :pending => :estimate
    end
  end

  def self.contacts_sort(attribute, category, forward)
    forward == "true" ? category.sort_by{|i| i.contacts.map{|j| j.name}} : category.sort_by{|i| i.contacts.map{|j| j.name}}.reverse
  end

  def self.category_sorting(attribute, category, forward)
    forward == "true" ? category.order("#{attribute} asc") :  category.order("#{attribute} desc")
  end

  def self.attribute_sort(attribute, category, forward)
    attribute_method = "#{attribute}_sort"
    if attribute_method != "contacts_sort"
      self.category_sorting(attribute, category, forward)
    else
      self.contacts_sort(attribute, category, forward)
    end
  end

  def self.group_invoices(group, kind)
    # self.users.map{|i| i.invoices.where(kind: kind).where('total is NOT NULL')}.flatten
    Invoice.includes(:users).where(kind: kind).where('total is NOT NULL').where('users.group_id' =>  "#{group.id}")
  end
end