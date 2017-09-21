class DeliveryMan < ApplicationRecord
  belongs_to :business
  has_many :deliveries
  belongs_to :trace, optional: true

  def to_s
    nickname
  end

  def last_trace
    trace if trace.changed?
  end

  def active_delivery
    Delivery.actives.where(delivery_man: self).first
  end

end
