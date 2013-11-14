# == Schema Information
#
# Table name: billing_docs
#
#  id         :integer          not null, primary key
#  total      :decimal(, )
#  note       :text
#  state      :string(255)
#  kind       :string(255)
#  group_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#  due_date   :string(255)
#

class BillingDoc < ActiveRecord::Base
  has_many :billing_docs_contacts
  has_many :contacts, through: :billing_docs_contacts
  has_many :line_items
  belongs_to :group

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

  def self.invoice
    where(kind: 'invoice')
  end

  def self.estimate
    where(kind: 'estimate')
  end

  def self.sort_by_ids(ids)
    where("id IN (#{ids})")
  end

  def self.sort_by_attribute(attribute, direction)
      self.order("#{attribute} #{direction}")
  end

  def self.sort_by_contacts(attribute, direction)
      self.includes(:contacts).order("contacts.name #{direction}")
  end

  def self.attribute_sort(attribute, forward)
    case attribute
    when "contacts"
      self.sort_by_contacts(attribute, forward)
    else
      self.sort_by_attribute(attribute, forward)
    end
  end

  def self.group_invoices(group, kind)
    self.includes(:users).where(kind: kind).where('total is NOT NULL').where('users.group_id' =>  "#{group.id}")
  end
end
