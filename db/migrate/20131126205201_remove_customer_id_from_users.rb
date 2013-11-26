class RemoveCustomerIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :customer_id, :string
  end
end
