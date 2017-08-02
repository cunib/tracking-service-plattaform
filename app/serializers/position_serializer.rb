class PositionSerializer < ActiveModel::Serializer
  attributes :latitude, :longitude, :created_at
end
