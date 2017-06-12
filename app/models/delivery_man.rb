class DeliveryMan < ApplicationRecord
  belongs_to :business
  has_many :deliveries
  has_one :trace

  def to_s
    nickname
  end
end
