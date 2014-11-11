class AddStripeIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_id, :string
    add_index :subscriptions, :stripe_id
  end
end
