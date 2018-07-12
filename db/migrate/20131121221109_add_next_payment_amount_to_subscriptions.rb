class AddNextPaymentAmountToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :next_payment_amount, :decimal, null: false, default: 0
  end
end
