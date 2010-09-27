class ChangeDefaultToTrueForEmailConfirmedOnUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :email_confirmed, :boolean, :default => true
  end

  def self.down
    change_column :users, :email_confirmed, :boolean, :default => false
  end
end
