class StripeCustomerIdNullFalse < ActiveRecord::Migration[4.2]
  def change
    change_column_default :users, :stripe_customer_id, ""
    change_column_null :users, :stripe_customer_id, false, ""
  end
end
