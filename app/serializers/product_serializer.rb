class ProductSerializer < ActiveModel::Serializer
  belongs_to :business
  attributes :id, :name, :description, :price
end
