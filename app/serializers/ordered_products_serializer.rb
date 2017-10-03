class OrderedProductsSerializer < ActiveModel::Serializer
  has_one :order
  has_one :product
  attributes :id, :amount
end
