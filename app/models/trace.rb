class Trace < ApplicationRecord
  belongs_to :position

  after_create :default_values

  def update_position(latitude, longitude)
    position.update(latitude: latitude, longitude: longitude)
  end

  private

  def default_values
    self.position = Position.create
  end
end
