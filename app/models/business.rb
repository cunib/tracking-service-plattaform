class Business < ApplicationRecord
  has_many :delivery_men
  has_many :orders
end
