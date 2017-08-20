class Order < ApplicationRecord
  enum status: { created: 0, development: 1, sended: 2, canceled: 3, finalized: 4, suspended: 5 } do
    event :process do
      transition [:created, :suspended] => :development
    end

    event :suspend do
      transition [:created, :development, :sended] => :suspended
    end

    event :cancel do
      transition [:created, :suspended, :development, :sended] => :canceled
    end

    event :dispatch do
      transition [:suspended, :development] => :sended
    end

    event :finalize do
      transition :sended => :finalized
    end
  end

  def can_cancel?
    created? || development? || sended? 
  end

  def can_suspend?
    created? || development? || sended? 
  end

  has_many :products
  belongs_to :business
  belongs_to :position, dependent: :destroy
  belongs_to :delivery

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
