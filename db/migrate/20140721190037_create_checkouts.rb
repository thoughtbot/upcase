class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :subscribeable, polymorphic: true, null: false
      t.integer :quantity, default: 1, null: false
      t.string :stripe_coupon_id
    end
  end
end
