class RenameUsersStripeCustomerToStripeCustomerId < ActiveRecord::Migration[4.2]
  def up
    rename_column :users, :stripe_customer, :stripe_customer_id
    rename_column :purchases, :stripe_customer, :stripe_customer_id
  end

  def down
    rename_column :users, :stripe_customer_id, :stripe_customer
    rename_column :purchases, :stripe_customer_id, :stripe_customer
  end
end
