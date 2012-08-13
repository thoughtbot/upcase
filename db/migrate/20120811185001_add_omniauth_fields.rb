class AddOmniauthFields < ActiveRecord::Migration
  def change
    add_column :users, :auth_provider, :string
    add_column :users, :auth_uid, :integer
  end
end
