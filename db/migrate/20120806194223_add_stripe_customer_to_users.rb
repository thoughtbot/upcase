class AddStripeCustomerToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :stripe_customer, :string
  end
end
