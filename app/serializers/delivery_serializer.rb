class DeliverySerializer < ActiveModel::Serializer
  has_one :delivery_man
  attributes :start_date, :end_date
end
