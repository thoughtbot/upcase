class AddPromotedToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :promoted, :boolean, null: false, default: false
  end
end
