class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :description
      t.float :price, default: 0.0
      
      t.timestamps
    end
  end
end
