class AddExternalProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :external_purchase_url, :text
    add_column :products, :external_purchase_name, :string
    add_column :products, :external_purchase_description, :string
  end
end
