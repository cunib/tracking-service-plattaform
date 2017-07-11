class Product < ApplicationRecord
  belongs_to :business

  def to_s
    name
  end
end
