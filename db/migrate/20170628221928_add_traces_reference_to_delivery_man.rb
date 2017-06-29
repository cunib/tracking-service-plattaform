class AddTracesReferenceToDeliveryMan < ActiveRecord::Migration[5.0]
  def change
    add_reference :delivery_men, :trace, foreign_key: true
  end
end
