class AddBillingEmailToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :billing_email, :string
  end
end
