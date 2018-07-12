class CreatePlans < ActiveRecord::Migration[4.2]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :sku, null: false
      t.string :short_description, null: false
      t.text :description, null: false
      t.boolean :active, null: false, default: true
      t.integer :individual_price, null: false
      t.integer :company_price, null: false
      t.text :terms
      t.boolean :includes_mentor, null: true, default: true
      t.boolean :includes_workshops, null: true, default: true
      t.boolean :featured, null: false, default: true

      t.timestamps
    end

    insert <<-SQL
      INSERT INTO plans
      (
        id, sku, name, short_description, description, individual_price,
        company_price, terms, created_at, updated_at
      )
      (
        SELECT id, sku, name, short_description, description, individual_price,
          company_price, terms, created_at, updated_at
        FROM products
        WHERE product_type='subscription'
      )
    SQL

    products = select_all "SELECT id FROM products where product_type='subscription'"
    products.each do |product|
      update <<-SQL
        UPDATE purchases
        SET purchaseable_type='Plan'
        WHERE purchaseable_id=#{product["id"]} AND purchaseable_type='Product'
      SQL
      delete "DELETE FROM products where id = #{product["id"]}"
    end

    add_column :subscriptions, :plan_id, :integer, null: true

    update <<-SQL
      UPDATE subscriptions
      SET stripe_plan_id = 'prime-basic'
      WHERE stripe_plan_id = 'prime-maintain'
    SQL

    update <<-SQL
      UPDATE subscriptions
      SET plan_id = plans.id FROM plans
      WHERE plans.sku = subscriptions.stripe_plan_id
    SQL

    change_column_null :subscriptions, :plan_id, false

    remove_column :subscriptions, :stripe_plan_id
  end
end
