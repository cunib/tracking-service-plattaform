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

  def update_trace(trace)
    trace_updated = true
    delivery_man_updated = trace.update_position trace.position.latitude, trace.position.longitude
    if active_delivery.present?
      trace_updated = Trace.create(trace.attributes.slice("date", "position_id").merge(delivery_id: 5)) && trace.save
    end
    delivery_man_updated && trace_updated
  end

  def active_delivery
    Delivery.actives.where(delivery_man: self).first
  end

end
