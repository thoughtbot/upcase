class ChangeDefaultToTrueForEmailConfirmedOnUsers < ActiveRecord::Migration[4.2]
  def self.up
    change_column :users, :email_confirmed, :boolean, :default => true
  end

  def self.down
    change_column :users, :email_confirmed, :boolean, :default => false
  end
end
