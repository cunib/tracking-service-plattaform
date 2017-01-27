class CreateDelivery < ActiveRecord::Migration[5.0]
  def change
    create_table :deliveries do |t|
      t.date :start_date
      t.date :end_date
      t.references :delivery_man, foreign_key: true
    end
  end
end
