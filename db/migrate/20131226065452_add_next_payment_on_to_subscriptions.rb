class AddNextPaymentOnToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :next_payment_on, :date
  end
end
