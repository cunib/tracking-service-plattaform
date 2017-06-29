class CreateTraces < ActiveRecord::Migration[5.0]
  def change
    create_table :traces do |t|
      t.datetime :date
      t.references :delivery, foreign_key: true

      t.timestamps
    end
  end
end
