# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id                  :integer          not null, primary key
#  full_name           :string           not null
#  email               :string           not null
#  revolut_customer_id :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_customers_on_email  (email) UNIQUE
#
class Customer < ApplicationRecord
  has_many :payment_method_setups, class_name: 'PaymentMethodSetup', dependent: :restrict_with_exception
  has_many :payment_methods, class_name: 'PaymentMethod', dependent: :restrict_with_exception
  has_many :payments, class_name: 'Payment', dependent: :restrict_with_exception

  validates :full_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true, allow_blank: true
  validate :readonly_revolut_customer_id

  def readonly_revolut_customer_id
    errors.add(:revolut_customer_id, 'is readonly') if revolut_customer_id_changed? && revolut_customer_id_was.present?
  end

  after_create :create_revolut_customer
  after_update :sync_revolut_customer
  after_destroy :remove_revolut_customer

  def display_name
    "#{id} | #{full_name}"
  end

  def revolut_customer
    RevolutMerchant::Client.customer(revolut_customer_id)
  rescue RevolutMerchant::Errors::ApiError => e
    {
      error_class: e.class.name,
      error_message: e.message,
      response_status: e.status,
      response_body: e.response_body
    }
  end

  private

  def create_revolut_customer
    revolut_customer = RevolutMerchant::Client.customer_create(email:, full_name:)
    update_columns(revolut_customer_id: revolut_customer[:id])
  end

  def sync_revolut_customer
    return if !saved_change_to_email? && !saved_change_to_full_name?

    RevolutMerchant::Client.customer_update(revolut_customer_id, email:, full_name:)
  end

  def remove_revolut_customer
    payment_method_setups.find_each(&:remove!)
    RevolutMerchant::Client.customer_delete(revolut_customer_id)
  end
end
