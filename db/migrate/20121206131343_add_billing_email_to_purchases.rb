class AddBillingEmailToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :billing_email, :string
  end
end
