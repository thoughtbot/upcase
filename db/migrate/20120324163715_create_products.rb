class CreateProducts < ActiveRecord::Migration[4.2]
  def self.up
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.string :tagline
      t.string :call_to_action
      t.string :short_description
      t.text   :description
      t.integer :price
      t.integer :company_price
      t.string  :product_type
      t.boolean :active, :default => true, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
