class DeliveryMan < ApplicationRecord
  belongs_to :business
  has_many :deliveries
  has_one :trace

  def to_s
    nickname
  end

  def last_trace
    trace if trace.changed?
  end
end
