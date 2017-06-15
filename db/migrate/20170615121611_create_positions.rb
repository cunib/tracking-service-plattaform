class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions do |t|
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.references :trace, foreign_key: true

      t.timestamps
    end
  end
end
