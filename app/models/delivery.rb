class Delivery < ApplicationRecord
  has_many :orders
  belongs_to :delivery_man
end
