class Order < ApplicationRecord
  enum status: { created: 0, development: 1, ready_to_send: 2, sended: 3, canceled: 4, finalized: 5, suspended: 6 } do
    event :process do
      transition [:created, :suspended] => :development
    end

    event :suspend do
      transition [:created, :development, :sended] => :suspended
    end

    event :cancel do
      transition [:created, :suspended, :development, :sended] => :canceled
    end

    event :mark_as_sended do
      transition [:suspended, :ready_to_send] => :sended
    end

    event :dispatch do
      transition [:suspended, :development] => :ready_to_send
    end

    event :finalize do
      transition :sended => :finalized
    end
  end

  scope :sended, -> { where(status: :sended) }
  scope :ready_to_send, -> { where(status: :ready_to_send, delivery_id: nil) }

  has_many :ordered_products
  has_many :products, through: :ordered_products
  belongs_to :business
  belongs_to :position, dependent: :destroy
  belongs_to :delivery, optional: true


  geocoded_by :address

  after_validation :geocode, if: ->(obj) { obj.address.present? and obj.address_changed? }
  after_save :save_position, if: ->(obj) { obj.address.present? and obj.address_changed? }

  #validate :position_present

  def can_cancel?
    !(canceled? || finalized?)
  end

  def can_suspend?
    !(canceled? || finalized? || suspended?)
  end

  def to_s
    address
  end

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
