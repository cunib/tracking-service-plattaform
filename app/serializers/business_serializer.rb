class BusinessSerializer < ActiveModel::Serializer
  #has_many :products
  attributes :name, :address
end
