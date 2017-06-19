class AddProductReferencesToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_reference :businesses, :product, foreign_key: true
  end
end
