class GlobalDiscount < ApplicationRecord
  validates :cart_min_value, :discount, presence: true

  enum statuses: {active: 'active', inactive: 'inactive'}

  validates :status, inclusion: { in: GlobalDiscount.statuses.values }

  scope :active, lambda{ where(status: GlobalDiscount.statuses[:active]) }
end
