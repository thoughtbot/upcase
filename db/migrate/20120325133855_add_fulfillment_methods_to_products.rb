class AddFulfillmentMethodsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :fulfillment_method, :string
    add_column :products, :github_team, :integer
    add_column :products, :github_url, :string
  end

  def self.down
    remove_column :products, :github_url
    remove_column :products, :github_team
    remove_column :products, :fulfillment_method
  end
end
