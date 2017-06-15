class AddPositionToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :position, foreign_key: true
  end
end
