class OrderSerializer < ActiveModel::Serializer
  has_one :business
  has_one :position
  has_one :delivery
  attributes :id, :start_date, :end_date, :address, :status
end
