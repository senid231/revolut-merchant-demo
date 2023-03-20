# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :build_customer, only: [:new, :create]
  before_action :find_customer, only: [:show, :edit, :update, :destroy]

  def index
    @customers = Customer.all.to_a
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    permitted_params = params.require(:customer).permit(:email, :full_name)
    @customer.assign_attributes(permitted_params)
    if @customer.save
      flash[:notice] = 'Customer created'
      redirect_to url_for(action: :index)
    else
      render :new, status: 422
    end
  end

  def update
    permitted_params = params.require(:customer).permit(:email, :full_name)
    @customer.assign_attributes(permitted_params)
    if @customer.save
      flash[:notice] = 'Customer updated'
      redirect_to url_for(action: :index)
    else
      render :edit, status: 422
    end
  end

  def destroy
    if @client.destroy
      flash[:notice] = 'Customer updated'
      redirect_to url_for(action: :index)
    else
      flash[:alert] = "Can't remove customer: #{@customer.errors.full_messages.to_sentence}"
      redirect_back fallback_location: url_for(action: :index)
    end
  end

  private

  def build_customer
    @customer = Customer.new
  end

  def find_customer
    @customer = Customer.find params[:id]
  end
end
