class DeliveryMan < ApplicationRecord
  belongs_to :business
  has_many :deliveries

  def to_s
    nickname
  end
end
