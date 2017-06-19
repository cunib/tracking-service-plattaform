class Product < ApplicationRecord
  belongs_to :business
	belongs_to :order

  def to_s
    name
  end
  
end
	