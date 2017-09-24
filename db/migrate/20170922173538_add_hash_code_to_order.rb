class AddHashCodeToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :hash_code, :string
  end
end
