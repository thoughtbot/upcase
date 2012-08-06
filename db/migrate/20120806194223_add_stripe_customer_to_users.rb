class AddStripeCustomerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer, :string
  end
end
