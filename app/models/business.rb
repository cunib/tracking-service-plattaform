class Business < ApplicationRecord
  has_many :delivery_men
  has_many :orders
  has_many :products

  def to_s
  	name
  end

  def deliveries
    Delivery.where(delivery_man_id: delivery_men.pluck(:id))
  end

end
