class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :item
      t.decimal :price
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
