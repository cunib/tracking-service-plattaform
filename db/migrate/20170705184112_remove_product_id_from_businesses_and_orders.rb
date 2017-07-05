class RemoveProductIdFromBusinessesAndOrders < ActiveRecord::Migration[5.0]
  def change
    remove_reference :businesses, :product, index: true, foreign_key: true
    remove_reference :orders, :product, index: true, foreign_key: true
  end
end
