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

  def update_trace(positions)
    last_position = positions.last
    updated = trace.update_position last_position[:latitude], last_position[:longitude]
    current_delivery.update_trace(positions)
    updated
  end

  def active_delivery
    Delivery.actives.where(delivery_man: self).first
  end

  private

  def current_delivery
    deliveries.last
  end
end
