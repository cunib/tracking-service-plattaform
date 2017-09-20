class TraceSerializer < ActiveModel::Serializer
  attributes :date
  belongs_to :position
  belongs_to :delivery
  has_one :delivery_man
end
