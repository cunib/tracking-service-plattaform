class Delivery < ApplicationRecord
  has_many :orders
  has_many :traces
  belongs_to :delivery_man
end
