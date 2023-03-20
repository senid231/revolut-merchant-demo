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
  validates :full_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true, allow_blank: true

  after_create :create_revolut_customer
  after_update :sync_revolut_customer
  after_destroy :remove_revolut_customer

  def active?
    revolut_customer_id.present?
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

  def create_revolut_customer
    revolut_customer = RevolutMerchant::Client.customer_create(email:, full_name:)
    update!(revolut_customer_id: revolut_customer[:id])
  end

  def sync_revolut_customer
    return if !saved_change_to_email? && !saved_change_to_full_name?

    RevolutMerchant::Client.customer_update(revolut_customer_id, email:, full_name:)
  end

  def remove_revolut_customer
    RevolutMerchant::Client.customer_delete(revolut_customer_id)
  end
end
