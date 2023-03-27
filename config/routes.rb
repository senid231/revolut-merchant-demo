# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: redirect('/customers')

  resources :customers
  resources :payment_methods, only: [:index, :show, :new, :create, :destroy]
  resources :payments, only: [:index, :show, :new, :create, :destroy] do
    member do
      post :pay
      post :confirm
    end
  end
  resources :payment_transactions, only: [:index, :show]
end
