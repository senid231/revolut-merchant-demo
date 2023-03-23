# frozen_string_literal: true

# == Schema Information
#
# Table name: payment_transactions
#
#  id                 :integer          not null, primary key
#  customer_id        :integer          not null
#  payment_id         :integer          not null
#  payment_method_id  :integer          not null
#  revolut_payment_id :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_payment_transactions_on_customer_id        (customer_id)
#  index_payment_transactions_on_payment_id         (payment_id)
#  index_payment_transactions_on_payment_method_id  (payment_method_id)
#
# Foreign Keys
#
#  customer_id        (customer_id => customers.id)
#  payment_id         (payment_id => payments.id)
#  payment_method_id  (payment_method_id => payment_methods.id)
#
class PaymentTransaction < ApplicationRecord
  belongs_to :customer, class_name: 'Customer'
  belongs_to :payment, class_name: 'Payment'
  belongs_to :payment_method, class_name: 'PaymentMethod'

  before_create { self.revolut_payment_id = create_revolut_payment[:id] }

  def revolut_payment
    RevolutMerchant::Client.payment(revolut_payment_id)
  end

  private

  def create_revolut_payment
    RevolutMerchant::Client.payment_create(
      payment.revolut_order_id,
      saved_payment_method: {
        type: 'card',
        id: payment_method.revolut_pm_id,
        initiator: 'merchant'
      }
    )
  end
end
