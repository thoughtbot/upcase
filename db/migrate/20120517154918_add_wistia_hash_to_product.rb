class AddWistiaHashToProduct < ActiveRecord::Migration
  def change
    add_column :products, :wistia_hash, :text
  end
end
