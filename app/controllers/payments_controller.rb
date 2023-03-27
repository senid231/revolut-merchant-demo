# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :build_payment, only: [:new, :create]
  before_action :find_payment, only: [:show, :pay, :confirm, :destroy]

  def index
    scope = Payment.preload(:customer)
    customer_id = params.dig(:q, :customer_id)
    scope = scope.where(customer_id:) if customer_id.present?
    @payments = scope.to_a
  end

  def show
    @revolut_order_state = @payment.revolut_order[:state]
  end

  def new
    customer = Customer.find params[:customer_id]
    @payment.assign_attributes(customer:)
  end

  def create
    permitted_params = params.require(:payment).permit(:amount, :customer_id, :force_three_ds)
    @payment.assign_attributes(permitted_params)
    if @payment.save
      flash[:notice] = 'Payment created'
      redirect_to payment_path(@payment.id)
    else
      render :new, status: 422
    end
  end

  def pay
    permitted_params = params.require(:payment_transaction).permit(:payment_method_id).to_h.symbolize_keys
    if @payment.pay(**permitted_params)
      flash[:notice] = 'Payment processing started'
    else
      flash[:alert] = "Can't remove payment: #{@payment.errors.full_messages.to_sentence}"
    end
    redirect_to payment_path(@payment.id)
  end

  def confirm
    if @payment.confirm
      flash[:notice] = 'Payment processing started'
    else
      flash[:alert] = "Can't remove payment: #{@payment.errors.full_messages.to_sentence}"
    end
    redirect_to payment_path(@payment.id)
  end

  def destroy
    if @payment.destroy
      flash[:notice] = 'Payment destroyed'
      redirect_to payments_path
    else
      flash[:alert] = "Can't remove payment: #{@payment.errors.full_messages.to_sentence}"
      redirect_back fallback_location: payment_path(@payment.id)
    end
  end

  private

  def build_payment
    @payment = Payment.new
  end

  def find_payment
    @payment = Payment.find params[:id]
  end

  def current_menu
    :payments
  end
end
