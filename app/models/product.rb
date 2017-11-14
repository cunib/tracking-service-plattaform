class Product < ApplicationRecord
  belongs_to :business
  has_many :ordered_products
  has_many :orders, through: :ordered_products

  def to_s
    "#{name} - $#{price}"
  end
end
