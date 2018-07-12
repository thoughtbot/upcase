class AddPaymentTransactionIdToPurchases < ActiveRecord::Migration[4.2]
  def self.up
    add_column :purchases, :payment_transaction_id, :string
  end

  def self.down
    remove_column :purchases, :payment_transaction_id
  end
end
