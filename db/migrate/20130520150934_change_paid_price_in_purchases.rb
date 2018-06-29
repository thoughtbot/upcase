class ChangePaidPriceInPurchases < ActiveRecord::Migration[4.2]
  def up
    change_column :purchases, :paid_price, :decimal
  end

  def down
    change_column :purchases, :paid_price, :integer
  end
end
