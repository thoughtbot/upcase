class AddPaidPriceToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :paid_price, :integer
  end
end
