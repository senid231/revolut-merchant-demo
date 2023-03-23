# frozen_string_literal: true

# == Schema Information
#
# Table name: payments
#
#  id                  :integer          not null, primary key
#  customer_id         :integer          not null
#  revolut_order_id    :string           not null
#  amount              :decimal(19, 2)   not null
#  status_id           :integer(2)       not null
#  force_three_ds      :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  last_transaction_id :integer
#
# Indexes
#
#  index_payments_on_customer_id          (customer_id)
#  index_payments_on_last_transaction_id  (last_transaction_id)
#
# Foreign Keys
#
#  customer_id          (customer_id => customers.id)
#  last_transaction_id  (last_transaction_id => payment_transactions.id)
#
class Payment < ApplicationRecord
  STATUS_ID_PENDING = 1
  STATUS_ID_WAIT_THREE_DS = 2
  STATUS_ID_COMPLETED = 3
  STATUS_ID_CANCELED = 4
  STATUS_IDS = {
    STATUS_ID_PENDING => 'Pending',
    STATUS_ID_WAIT_THREE_DS => 'Wait 3DS',
    STATUS_ID_COMPLETED => 'Completed',
    STATUS_ID_CANCELED => 'Canceled'
  }.freeze

  belongs_to :customer, class_name: 'Customer'
  has_many :transactions, class_name: 'PaymentTransaction', dependent: :restrict_with_exception
  belongs_to :last_transaction, class_name: 'PaymentTransaction', optional: true

  attr_readonly :customer_id

  before_validation(on: :create) { self.status_id = STATUS_ID_PENDING }
  validates :amount, numericality: { greater_than_or_equal_to: 0.01 }
  validates :status_id, inclusion: { in: STATUS_IDS.keys }

  before_create { self.revolut_order_id = create_revolut_order[:id] }

  def display_name
    "#{id} | $#{amount} (#{status})"
  end

  def status
    STATUS_IDS[status_id]
  end

  def pending?
    status_id == STATUS_ID_PENDING
  end

  def wait_three_ds?
    status_id == STATUS_ID_WAIT_THREE_DS
  end

  def canceled?
    status_id == STATUS_ID_CANCELED
  end

  def completed?
    status_id == STATUS_ID_COMPLETED
  end

  # https://developer.revolut.com/docs/accept-payments/tutorials/save-and-charge-payment-methods/checkout-with-saved-card/
  # https://developer.revolut.com/docs/accept-payments/3d-secure-overview/
  def pay(payment_method_id:)
    payment_method = customer.payment_methods.find(payment_method_id)
    # error if status_id != pending

    order_data = revolut_order
    case order_data[:state]
    when RevolutMerchant::CONST::ORDER_STATE_PENDING
      # transaction should be created
      last_transaction = PaymentTransaction.create!(payment: self, payment_method:, customer:)
      update!(last_transaction:)
    when RevolutMerchant::CONST::ORDER_STATE_AUTHORISED
      errors.add(:base, 'payment already paid')
      true
    when RevolutMerchant::CONST::ORDER_STATE_COMPLETED
      errors.add(:base, 'payment already completed')
      false
    else
      raise ArgumentError, "invalid revolut order #{order_data[:id]} state #{order_data[:state]}"
    end
  end

  def confirm
    if completed?
      errors.add(:base, 'payment already completed')
      return false
    end

    if revolut_order[:state] != RevolutMerchant::CONST::ORDER_STATE_COMPLETED
      RevolutMerchant::Client.order_capture(revolut_order_id)
    end
    update(status_id: STATUS_ID_COMPLETED)
  end

  def revolut_order
    RevolutMerchant::Client.order(revolut_order_id)
  end

  private

  def create_revolut_order
    amount_cents = (amount * 100).to_i
    enforce_challenge = if force_three_ds
                          RevolutMerchant::CONST::ENFORCE_CHALLENGE_FORCED
                        else
                          RevolutMerchant::CONST::ENFORCE_CHALLENGE_AUTOMATIC
                        end
    RevolutMerchant::Client.order_create(
      customer_id: customer.revolut_customer_id,
      amount: amount_cents,
      currency: RevolutMerchant::CONST::CURRENCY_USD,
      capture_mode: RevolutMerchant::CONST::CAPTURE_MODE_MANUAL,
      enforce_challenge:
    )
  end
end
