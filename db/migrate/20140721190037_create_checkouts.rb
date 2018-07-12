class CreateCheckouts < ActiveRecord::Migration[4.2]
  def change
    create_table :checkouts do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :subscribeable, polymorphic: true, null: false
      t.integer :quantity, default: 1, null: false
      t.string :stripe_coupon_id
      t.timestamps
    end
    insert(<<-SQL)
      INSERT INTO checkouts
        (user_id, subscribeable_id, subscribeable_type, quantity, stripe_coupon_id, created_at, updated_at)
        (SELECT DISTINCT ON (user_id, purchaseable_id, purchaseable_type)
            user_id, purchaseable_id, purchaseable_type, quantity, stripe_coupon_id, created_at, updated_at
            FROM purchases
            WHERE
              user_id IS NOT NULL AND
              purchaseable_id IS NOT NULL AND
              purchaseable_type like '%Plan'
        )
    SQL
  end
end
