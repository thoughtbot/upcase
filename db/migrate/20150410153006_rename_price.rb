class RenamePrice < ActiveRecord::Migration
  def change
    rename_column :plans, :price, :price_in_dollars
  end
end
