# frozen_string_literal: true

# == Schema Information
#
# Table name: payment_methods
#
#  id              :integer          not null, primary key
#  customer_id     :integer          not null
#  revolut_pm_id   :string           not null
#  card_brand      :string           not null
#  card_last_four  :string           not null
#  card_expired_at :date             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_payment_methods_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  customer_id  (customer_id => customers.id)
#
class PaymentMethod < ApplicationRecord
  belongs_to :customer, class_name: 'Customer'

  class << self
    def create_from_revolut_pm!(customer:, revolut_pm:)
      create!(
        customer:,
        revolut_pm_id: revolut_pm[:id],
        card_brand: revolut_pm.dig(:card, :card_brand),
        card_last_four: revolut_pm.dig(:card, :card_last_four),
        card_expired_at: Date.strptime(revolut_pm.dig(:card, :card_expiry), '%m/%Y').end_of_month
      )
    end
  end

  def revolut_pm
    RevolutMerchant::Client.payment_method(customer.revolut_customer_id, revolut_pm_id)
  end

  def card_number
    "****#{card_last_four}"
  end

  def card_expiry
    card_expired_at.strftime('%m/%Y')
  end

  def display_name
    "#{id} | #{card_number} #{card_expiry}"
  end
end
