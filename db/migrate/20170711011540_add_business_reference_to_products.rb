class AddBusinessReferenceToProducts < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :business, foreign_key: true
  end
end
