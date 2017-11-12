class OrdersSerializer < ActiveModel::Serializer
  belongs_to :business
  belongs_to :position
  has_one :delivery
  has_many :ordered_products
  attributes :id, :start_date, :end_date, :address, :status, :customer_full_name, :customer_email
end
