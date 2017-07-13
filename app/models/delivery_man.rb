class DeliveryMan < ApplicationRecord
  belongs_to :business
  has_many :deliveries
  has_one :trace

  def to_s
    nickname
  end

  def last_trace
    trace if trace.changed?
  end

  def update_trace(positions)
    last_position = positions.last
    updated = trace.position.update latitude: last_position.latitude, longitude: last_position.longitude
    current_delivery.update_trace(positions)
    updated
  end

  private

  def current_delivery
    deliveries.last
  end
end
