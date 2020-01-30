class CreateProductDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :product_discounts do |t|
      t.integer :product_id
      t.integer :discount_id
      t.integer :quantity

      t.timestamps
    end
  end
end
