class AddDeliveryReferencesToOrder < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :delivery, foreign_key: true
  end
end
