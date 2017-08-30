class OrderedProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_validation :set_amount

  private

  def set_amount
    self.amount = product.price
  end
end
