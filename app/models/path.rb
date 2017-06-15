class Path < ApplicationRecord
  belongs_to :delivery
  belongs_to :position
end
