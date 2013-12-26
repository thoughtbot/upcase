class AddNextPaymentAmountToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :next_payment_amount, :decimal, null: false, default: 0
  end
end
