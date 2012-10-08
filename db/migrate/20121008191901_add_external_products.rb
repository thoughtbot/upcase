class AddExternalProducts < ActiveRecord::Migration
  def change
    add_column :products, :external_purchase_url, :text
    add_column :products, :external_purchase_name, :string
    add_column :products, :external_purchase_description, :string
  end
end
