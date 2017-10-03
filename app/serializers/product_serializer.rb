class ProductSerializer < ActiveModel::Serializer
  belongs_to :business
  has_many :ordered_products
  has_many :orders, through: :ordered_products
  has_many :ordered_products
  attributes :id, :name, :description, :price
end
