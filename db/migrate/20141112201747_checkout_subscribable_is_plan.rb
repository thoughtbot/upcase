class CheckoutSubscribableIsPlan < ActiveRecord::Migration
  def change
    remove_column :checkouts, :subscribeable_type
    rename_column :checkouts, :subscribeable_id, :plan_id
  end
end
