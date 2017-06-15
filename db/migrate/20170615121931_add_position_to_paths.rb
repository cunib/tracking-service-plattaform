class AddPositionToPaths < ActiveRecord::Migration[5.0]
  def change
    add_reference :paths, :position, foreign_key: true
  end
end
