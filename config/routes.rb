# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/customers')
  resources :customers do
    resources :payment_methods
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
