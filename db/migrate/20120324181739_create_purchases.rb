class CreatePurchases < ActiveRecord::Migration[4.2]
  def self.up
    create_table :purchases do |t|
      t.belongs_to  :product
      t.string      :stripe_customer
      t.string      :variant
      t.string      :name
      t.string      :email
      t.string      :organization
      t.string      :address1
      t.string      :address2
      t.string      :city
      t.string      :state
      t.string      :zip_code

      t.timestamps
    end
    add_index :purchases, :product_id
    add_index :purchases, :stripe_customer
  end

  def self.down
    drop_table :purchases
  end
end
