class CreateDeliveryMan < ActiveRecord::Migration[5.0]
  def change
    create_table :delivery_men do |t|
      t.string :nickname
      t.references :business, foreign_key: true
    end
  end
end
