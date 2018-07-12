class RemoveCustomerIdFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :customer_id, :string
  end
end
