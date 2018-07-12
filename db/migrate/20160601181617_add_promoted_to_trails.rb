class AddPromotedToTrails < ActiveRecord::Migration[4.2]
  def change
    add_column :trails, :promoted, :boolean, null: false, default: false
  end
end
