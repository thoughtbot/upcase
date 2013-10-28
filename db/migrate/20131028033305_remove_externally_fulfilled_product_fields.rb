class RemoveExternallyFulfilledProductFields < ActiveRecord::Migration
  def up
    remove_column :products, :external_purchase_url
    remove_column :products, :external_purchase_name
    remove_column :products, :external_purchase_description
  end

  def down
    add_column :products, :external_purchase_url, :text
    add_column :products, :external_purchase_name, :string
    add_column :products, :external_purchase_description, :string
  end
end
