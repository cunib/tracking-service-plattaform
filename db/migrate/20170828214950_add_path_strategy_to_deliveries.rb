class AddPathStrategyToDeliveries < ActiveRecord::Migration[5.0]
  def change
    add_column :deliveries, :path_strategy, :string
  end
end
