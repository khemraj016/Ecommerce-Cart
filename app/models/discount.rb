class Discount < ApplicationRecord
  validates :price, :total_quantity, presence: true

  has_many :product_discounts

  enum statuses: {active: 'active', inactive: 'inactive'}

  validates :status, inclusion: { in: Discount.statuses.values }

  accepts_nested_attributes_for :product_discounts, allow_destroy: true

  scope :active, lambda{ where(status: Discount.statuses[:active]) }
end
