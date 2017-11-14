class CreateOrder < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :address
      t.references :business, foreign_key: true
    end
  end
end
