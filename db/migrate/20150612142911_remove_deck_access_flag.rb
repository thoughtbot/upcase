class RemoveDeckAccessFlag < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :has_deck_access
  end
end
