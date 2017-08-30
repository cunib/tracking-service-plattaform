class CreateOrderedProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :ordered_products do |t|
      t.references :order, foreign_key: true
      t.references :product, foreign_key: true
      t.float :amount
    end
  end
end
