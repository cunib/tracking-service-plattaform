class AddCustomerAttributesToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :customer_full_name, :string
    add_column :orders, :customer_email, :string
  end
end
