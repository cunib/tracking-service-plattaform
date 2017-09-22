class AddBusinessReferenceToDeliveries < ActiveRecord::Migration[5.0]
  def change
    add_reference :deliveries, :business, foreign_key: true
  end
end
