module ProductsHelper
  def discount_items_price
    carts = Cart.includes(:product).where(user_id: guest_user.id, status: 'active')
    cart_price = 0;
    product_quantity_mapping = {}
    carts.each do |cart|
      product = cart.product
      cart_price += product.price * cart.quantity
      product_quantity_mapping[product.id] = cart.quantity
    end
    product_ids = carts.pluck(:product_id)
    quantities = carts.pluck(:quantity)

    total_quantity = quantities.sum
    discounts = Discount.where('total_quantity <= ?',  total_quantity)

    discount_price = 0
    discounts.each do |discount|
      product_discount = discount.product_discounts.where(product_id: product_ids).last
      next if product_discount.blank?
      cart = Cart.where(product_id: product_discount.product_id, quantity: product_discount.quantity)
      next if cart.blank?
      discount_price += discount.price
      product_quantity_mapping[product_discount.product_id] -= product_discount.quantity
      total_quantity -= product_discount.quantity
    end
    # discount_ids = []
    # product_ids.each_with_index do |product_id, index|
    #   discount_ids << ProductDiscount.where('product_id = ? and quantity <= ?', product_id, quantities[index]).pluck(:discount_id)
    # end
    # final_discount_ids = discount_ids.inject(:&)
    # discount_price = Discount.where(id: final_discount_ids).active.pluck(:price).max.to_d
    # total = discount_price.zero? ? cart_price : discount_price
    
    if discount_price.present?
      total = discount_price
    end

    carts.each do |cart|
      next if product_quantity_mapping[cart.product_id].zero?
      total += cart.product.price
    end
    
    additional_discount = GlobalDiscount.where('cart_min_value <= ?', total).active.pluck(:discount).max.to_d
    
    {
      cart_price: cart_price, discount_price: discount_price, 
      additional_discount: additional_discount, total: total - additional_discount
    }
  end
end
