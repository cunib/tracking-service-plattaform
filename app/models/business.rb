class Business < ApplicationRecord
  has_many :delivery_men
  has_many :orders
  has_many :products
  belongs_to :position, dependent: :destroy

  validates :name, :address, :path_strategy, presence: true

  def to_s
  	name
  end

  def deliveries
    Delivery.where(delivery_man_id: delivery_men.pluck(:id))
  end

  geocoded_by :address

  after_validation :geocode, if: ->(obj) { obj.address.present? and obj.address_changed? }
  after_save :save_position, if: ->(obj) { obj.address.present? and obj.address_changed? }

  #validate :position_present

  def latitude=(latitude)
    position.latitude = latitude
  end

  def longitude=(longitude)
    position.longitude = longitude
  end

  def latitude
    position.latitude
  end

  def longitude
    position.longitude
  end

  private

  def position_present
    if (position.latitude.nil? && position.longitude.nil?)
      errors.add :position, :geocode_fail
      throw :abort
    end
  end

  def save_position
    position.save
  end
end
