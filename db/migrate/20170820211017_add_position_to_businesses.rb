class AddPositionToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_reference :businesses, :position, foreign_key: true
  end
end
