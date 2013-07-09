class DropPurchasesBillingEmail < ActiveRecord::Migration
  def up
    remove_column :purchases, :billing_email
  end

  def down
    add_column :purchases, :billing_email, :string
  end
end
