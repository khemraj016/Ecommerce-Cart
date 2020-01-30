class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.decimal :price
      t.integer :total_quantity
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
