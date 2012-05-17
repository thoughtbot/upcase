class AddWistiaIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :wistia_id, :string
  end
end
