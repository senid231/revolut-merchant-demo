# frozen_string_literal: true

class PaymentMethodsController < ApplicationController
  before_action :find_customer
  before_action :find_payment_method, only: [:show, :destroy]

  def show
  end

  def new
    @payment_method_setup = PaymentMethodSetup.create!(customer: @customer)
    @revolut_mode = RevolutMerchant.config.mode
  end

  def create
    pm_setup_id = params.require(:payment_method).permit(:payment_method_setup_id)[:payment_method_setup_id]
    pm_setup = PaymentMethodSetup.find(pm_setup_id)
    if pm_setup.confirm
      flash[:notice] = 'Payment method created'
    else
      flash[:alert] = 'Payment method creation failed'
    end
    redirect_to customer_path(@customer.id)
  end

  def destroy
    if @payment_method.destroy
      flash[:notice] = 'Payment method destroyed'
      redirect_to customer_path(@customer.id)
    else
      flash[:alert] = "Can't remove customer: #{@customer.errors.full_messages.to_sentence}"
      redirect_back fallback_location: customer_path(@customer.id)
    end
  end

  private

  def find_customer
    @customer = Customer.find params[:customer_id]
  end

  def find_payment_method
    @payment_method = PaymentMethod.find params[:id]
  end

  def current_menu
    :customers
  end
end
