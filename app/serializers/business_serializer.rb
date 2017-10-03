class BusinessSerializer < ActiveModel::Serializer
  has_many :products
  has_one :position
  attributes :name, :address
end
