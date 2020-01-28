class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token

  include ProductsHelper
  
  def index
    @products = Product.active
  end

  def cart
    cart = Cart.where(user_id: guest_user.id, product_id: params[:product][:id]).first_or_initialize
    cart.update_attributes!(quantity: params[:product][:quantity], status: 'active')
    render json: {success: true}
  end

  def cart_clear
    carts = Cart.where(user_id: guest_user.id, status: 'active')
    carts.update_all(quantity: 0, status: 'inactive')
    render json: {success: true}
  end

  def calculate
    render json: {success: true, data: discount_items_price }
  end
end
