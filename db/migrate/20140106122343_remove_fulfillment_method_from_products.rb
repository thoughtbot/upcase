class RemoveFulfillmentMethodFromProducts < ActiveRecord::Migration[4.2]
  def change
    remove_column :products, :fulfillment_method, :string
  end
end
