class Product < ApplicationRecord
  validates :item, :price, presence: true

  enum statuses: {active: 'active', inactive: 'inactive'}

  validates :status, inclusion: { in: Product.statuses.values }

  scope :active, lambda{ where(status: Product.statuses[:active]) }

  has_many :product_discounts
  has_many :discounts, through: :product_discounts
end
