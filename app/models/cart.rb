class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true

  enum statuses: {active: 'active', inactive: 'inactive'}

  validates :status, inclusion: { in: Cart.statuses.values }
  
  scope :active, lambda{ where(status: Cart.statuses[:active]) }
end
