# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#populating the initial product data
items = ['A', 'B', 'C', 'D']
prices = [30, 20, 50, 15]

items.each_with_index do |item, index|
  Product.where(item: item, price: prices[index]).first_or_create
end

discount_name = ['discount_on_item_A', 'discount_on_item_B']
discount_prices = [75, 35]
product_ids = Product.where(item: ['A', 'B']).pluck(:id)
quantities = [3, 2]

discount_name.each_with_index do |name, index|
  discount = Discount.where(name: name, price: discount_prices[index], total_quantity: quantities[index])
                     .first_or_create
  product_discount = ProductDiscount.where(
    product_id: product_ids[index], discount_id: discount.id, quantity: quantities[index]
  ).first_or_create
end

GlobalDiscount.where(cart_min_value: 150, discount: 20).first_or_create