class ProductDiscount < ApplicationRecord
  validates :quantity, presence: true

  belongs_to :product
  belongs_to :discount, -> { where(status: 'active') }
end
