Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  root to: 'products#index'

  get 'products/calculate'
  get 'products/cart_clear'
  post 'products/cart'
end

