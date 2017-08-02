class OrdersSerializer < ActiveModel::Serializer
  belongs_to :business
  belongs_to :position
  has_one :delivery
  attributes :id, :start_date, :end_date, :address, :status
end
