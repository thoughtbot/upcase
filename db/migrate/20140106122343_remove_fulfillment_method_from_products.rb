class RemoveFulfillmentMethodFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :fulfillment_method, :string
  end
end
