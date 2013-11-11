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
    event :invoice do
      transition all => :invoice
    end
    event :estimate do
      transition :pending => :estimate
    end
  end

  def user_filter
    self.select{|i| i.contacts.select{|j| j.user_id = current_user.id}}
  end

  def self.contacts_sort(attribute, category, forward)
    forward == "true" ? category.sort_by{|i| i.contacts.map{|j| j.name}} : category.sort_by{|i| i.contacts.map{|j| j.name}}.reverse
  end

  def self.category_sorting(attribute, category, forward)
    forward == "true" ? category.order("#{attribute} asc") :  category.order("#{attribute} desc")
  end

  def self.attribute_sort(attribute, category, forward)
    # binding.pry
    attribute_method = "#{attribute}_sort"
    if attribute_method != "contacts_sort"
      Invoice.category_sorting(attribute, category, forward)
    else
      Invoice.contacts_sort(attribute, category, forward)
    end
  end
  #category will give either @estimates or @invoices
  #attribute will give... no shit.

end


# open/closed for invoice  (so true or false or null, don't show that column )
# not applicable to estimate

# invoice / estimate