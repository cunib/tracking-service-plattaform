class Delivery < ApplicationRecord
  attr_accessor :status
  enum statuses: [:active, :finalized]

  has_many :orders, dependent: :restrict_with_error
  has_many :traces
  has_many :paths
  has_many :redord, class_name: 'Path'
  belongs_to :delivery_man, optional: true
  belongs_to :business

  scope :actives, -> { joins("LEFT OUTER JOIN orders on orders.delivery_id = deliveries.id")
    .merge(Order.sended)
    .or(joins("LEFT OUTER JOIN orders on orders.delivery_id = deliveries.id").merge(Order.suspended)) }

  validates :orders, presence: true
  after_create :mark_orders_as_sended

  def status
    if active?
      :active
    else
      if ready_to_send?
        :ready_to_send
      else
        :finalized
      end
    end
  end

  def last_positions
    traces.map(&:position)
  end

  def serialized_positions
    traces.map do |trace|
      {
        title: delivery_man.nickname,
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
        status: order.status,
        id: order.id
      }
    end
  end

  def sended_orders
    orders.sended
  end

  def not_sended_orders
    orders.not_sended
  end

  def active?
    orders.where(status: [:sended]).any?
  end

  def ready_to_send?
    orders.where(status: [:ready_to_send]).count == orders.count
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
    result = false
    orders.each { |order| result = order.mark_as_sended! } unless active?
    errors.add :base, :not_activated unless result
    self
  end

  def can_activate?
    return false unless delivery_man.present?
    ready_to_send? && delivery_man.active_delivery.blank?
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
