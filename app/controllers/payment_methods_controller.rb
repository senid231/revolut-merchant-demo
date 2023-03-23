# frozen_string_literal: true

class PaymentMethodsController < ApplicationController
  before_action :find_payment_method, only: [:show, :destroy]

  def index
    scope = PaymentMethod.preload(:customer)
    customer_id = params.dig(:q, :customer_id)
    scope = scope.where(customer_id:) if customer_id.present?
    @payment_methods = scope.to_a
  end

  def show
  end

  def new
    customer = Customer.find params[:customer_id]
    @payment_method_setup = PaymentMethodSetup.create!(customer:)
  end

  def create
    permitted_params = params.require(:payment_method).permit(:payment_method_setup_id)
    pm_setup = PaymentMethodSetup.find permitted_params[:payment_method_setup_id]
    payment_method = pm_setup.confirm
    if payment_method
      flash[:notice] = 'Payment method created'
    else
      flash[:alert] = 'Payment method creation failed'
    end
    redirect_to payment_method_path(payment_method.id)
  end

  def destroy
    customer_id = @payment_method.customer_id
    if @payment_method.destroy
      flash[:notice] = 'Payment method destroyed'
      redirect_to customer_path(customer_id)
    else
      flash[:alert] = "Can't remove payment method: #{@payment_method.errors.full_messages.to_sentence}"
      redirect_to payment_methods_path
    end
  end

  private

  def find_payment_method
    @payment_method = PaymentMethod.find params[:id]
  end

  def current_menu
    :payment_methods
  end
end
