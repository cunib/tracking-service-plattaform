class AddPositionsReferenceToTrace < ActiveRecord::Migration[5.0]
  def change
    add_reference :traces, :position, foreign_key: true
  end
end
