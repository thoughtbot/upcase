class AddNextPaymentOnToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :next_payment_on, :date
  end
end
