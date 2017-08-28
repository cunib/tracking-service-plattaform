class AddPathStrategyToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :path_strategy, :string
  end
end
