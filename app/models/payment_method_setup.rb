# frozen_string_literal: true

# == Schema Information
#
# Table name: payment_method_setups
#
#  id               :integer          not null, primary key
#  customer_id      :integer          not null
#  revolut_order_id :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_payment_method_setups_on_customer_id       (customer_id)
#  index_payment_method_setups_on_revolut_order_id  (revolut_order_id) UNIQUE
#
# Foreign Keys
#
#  customer_id  (customer_id => customers.id)
#
class PaymentMethodSetup < ApplicationRecord
  ORDER_AMOUNT_CENTS = 100

  belongs_to :customer, class_name: 'Customer'

  attr_readonly :customer_id

  before_create do
    self.revolut_order_id = create_revolut_order[:id]
  end

  # not confirmed payment method setups removed automatically in cron task
  scope :ready_to_remove, -> { where("#{table_name}.created_at < ?", 24.hours.ago) }

  def remove
    order_data = revolut_order
    case order_data[:state]
    when RevolutMerchant::CONST::ORDER_STATE_PENDING, RevolutMerchant::CONST::ORDER_STATE_AUTHORISED
      RevolutMerchant::Client.order_delete(revolut_order_id)
      destroy!
    when RevolutMerchant::CONST::ORDER_STATE_CANCELLED, RevolutMerchant::CONST::ORDER_STATE_FAILED
      destroy!
    when RevolutMerchant::CONST::ORDER_STATE_COMPLETED
      refund_revolut_order if order_data[:refunded_amount][:value].zero?
      destroy!
    when RevolutMerchant::CONST::ORDER_STATE_PROCESSING
      errors.add(:base, 'order is waiting for processing')
      # payment_method_setup can be confirmed later
      false
    else
      raise ArgumentError, "invalid revolut order #{order_data[:id]} state #{order_data[:state]}"
    end
  end

  def confirm
    order_data = revolut_order
    case order_data[:state]
    when RevolutMerchant::CONST::ORDER_STATE_AUTHORISED
      order_data = capture_revolut_order
      revolut_pm = retrieve_revolut_pm(order_data)
      refund_revolut_order
      PaymentMethod.create_from_revolut_pm!(customer:, revolut_pm:)
    when RevolutMerchant::CONST::ORDER_STATE_COMPLETED
      revolut_pm = retrieve_revolut_pm(order_data)
      refund_revolut_order if order_data[:refunded_amount][:value].zero?
      PaymentMethod.create_from_revolut_pm!(customer:, revolut_pm:)
      true
    when RevolutMerchant::CONST::ORDER_STATE_PENDING, RevolutMerchant::CONST::ORDER_STATE_PROCESSING,
      errors.add(:base, "order state is #{order_data[:state]}")
      # payment_method_setup can be confirmed later
      false
    when RevolutMerchant::CONST::ORDER_STATE_CANCELLED, RevolutMerchant::CONST::ORDER_STATE_FAILED
      errors.add(:base, "order state is #{order_data[:state]}")
      # payment_method_setup can be destroyed
      false
    else
      raise ArgumentError, "invalid revolut order #{order_data[:id]} state #{order_data[:state]}"
    end
  end

  def revolut_order
    RevolutMerchant::Client.order(revolut_order_id)
  end

  def revolut_order_public_id
    revolut_order[:public_id]
  end

  private

  def retrieve_revolut_pm(order_data)
    order_data[:payments].last[:payment_method]
  end

  def create_revolut_order
    RevolutMerchant::Client.order_create(
      customer_id: customer.revolut_customer_id,
      amount: ORDER_AMOUNT_CENTS,
      currency: RevolutMerchant::CONST::CURRENCY_USD,
      description: 'Create Payment Method',
      metadata: { description: revolut_description },
      capture_mode: RevolutMerchant::CONST::CAPTURE_MODE_MANUAL,
      enforce_challenge: RevolutMerchant::CONST::ENFORCE_CHALLENGE_FORCED
    )
  end

  def capture_revolut_order
    RevolutMerchant::Client.order_capture(revolut_order_id)
  end

  def refund_revolut_order
    RevolutMerchant::Client.order_refund(
      revolut_order_id,
      amount: ORDER_AMOUNT_CENTS,
      metadata: { description: revolut_description }
    )
  end

  def revolut_description
    "payment_method_setup customer:#{customer_id}"
  end
end
