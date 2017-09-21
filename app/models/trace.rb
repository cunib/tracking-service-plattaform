class Trace < ApplicationRecord
  belongs_to :position
  belongs_to :delivery, optional: true
  has_one :delivery_man

  before_validation :default_values, on: :create

  def update_position(latitude, longitude)
    unless position.update(latitude: latitude, longitude: longitude)
      errors.add :base, :position_update_fail
    end
  end

  private

  def default_values
    self.position = self.position || Position.create
  end
end
