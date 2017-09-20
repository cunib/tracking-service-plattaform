class Delivery < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error
  has_many :traces
  has_many :paths
  has_many :redord, class_name: 'Path'
  belongs_to :delivery_man

  scope :actives, -> { joins(:orders).merge(Order.sended) }

  after_create :mark_orders_as_sended

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

  def active?
    active = false
    orders.each { |o| active = active || o.sended? }
    active
  end

  def deliver
    update_attribute start_date: DateTime.now
  end

  def finalize
    update_attribute end_date: DateTime.now
  end

  def to_s
    "#{delivery_man}-##{id}-#{start_date.to_s}"
  end

  def activate
    orders.each { |order| order.mark_as_sended! } unless active?
  end

  def can_activate?
    can_activate = false
    orders.each { |o| can_activate = can_activate || o.ready_to_send? }
    can_activate
  end

  private

  def mark_orders_as_sended
    orders.each { |order| }
  end

  def create_trace(latitude, longitude)
    position = Position.create latitude: latitude, longitude: longitude
    Trace.create delivery_id: self.id, date: DateTime.now, position: position
  end
end
