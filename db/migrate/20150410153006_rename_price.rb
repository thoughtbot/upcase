class RenamePrice < ActiveRecord::Migration[4.2]
  def change
    rename_column :plans, :price, :price_in_dollars
  end
end
