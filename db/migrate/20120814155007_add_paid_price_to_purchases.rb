class AddPaidPriceToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :paid_price, :integer
  end
end
