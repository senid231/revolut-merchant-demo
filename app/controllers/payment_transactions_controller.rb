# frozen_string_literal: true

class PaymentTransactionsController < ApplicationController
  before_action :find_payment_transaction, only: [:show]

  def show
  end

  private

  def find_payment_transaction
    @payment_transaction = PaymentTransaction.find params[:id]
  end

  def current_menu
    :payment_transactions
  end
end
