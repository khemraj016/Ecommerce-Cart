class CreateGlobalDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :global_discounts do |t|
      t.decimal :cart_min_value
      t.decimal :discount
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
