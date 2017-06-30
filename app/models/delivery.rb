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
end
