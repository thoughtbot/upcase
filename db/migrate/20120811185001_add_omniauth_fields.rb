class AddOmniauthFields < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :auth_provider, :string
    add_column :users, :auth_uid, :integer
  end
end
