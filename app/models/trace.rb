class Trace < ApplicationRecord
  belongs_to :position
  belongs_to :delivery, optional: true
  has_one :delivery_man

  after_create :default_values

  def self.build_trace(params)
    position = Position.create latitude: params[:latitude], longitude: params[:longitude]
    Trace.new date: params[:date], position: position
  end

  def update_position(latitude, longitude)
    position.update(latitude: latitude, longitude: longitude)
  end

  private

  def default_values
    position = position || Position.create
    true
  end
end
