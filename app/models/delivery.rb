class Delivery < ApplicationRecord
  has_many :orders
  has_many :traces
  has_many :paths
  has_many :redord, class_name: 'Path'
  belongs_to :delivery_man

  def last_positions
    traces.map(&:position)
  end

  def serialized_positions
    traces.map do |trace|
      {
        title: trace.date.to_s,
        position: {
          lat: trace.position.latitude,
          lng: trace.position.longitude
        },
        id: trace.id
      }
    end
  end

  def serialized_orders
    orders.map do |order|
      {
        title: order.address,
        position: {
          lat: order.position.latitude,
          lng: order.position.longitude
        },
        id: order.id
      }
    end
  end

  def update_trace(positions)
    if active?
      positions.each { |p| traces << Trace.create latitude: p.latitude, longitude. p.longitude }
    end
  end

  def active?
    active = false
    orders.each { |o| active = active || o.sended? }
    active
  end

  def to_s
    "##{id}-#{start_date.to_s}"
  end
end
