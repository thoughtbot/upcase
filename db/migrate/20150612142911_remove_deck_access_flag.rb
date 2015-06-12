class RemoveDeckAccessFlag < ActiveRecord::Migration
  def change
    remove_column :users, :has_deck_access
  end
end
