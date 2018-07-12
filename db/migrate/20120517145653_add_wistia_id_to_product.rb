class AddWistiaIdToProduct < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :wistia_id, :string
  end
end
