class AddPurchasesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :user_id, :integer
  end
end
