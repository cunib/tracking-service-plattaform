class BusinessSerializer < ActiveModel::Serializer
  has_one :position
  attributes :name, :address
end
