class DeliveryManSerializer < ActiveModel::Serializer
  has_one :business
  has_many :deliveries
  #has_one :trace
  attributes :id, :nickname, :business_id
end
