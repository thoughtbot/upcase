class AddPositionIndex < ActiveRecord::Migration
  def change
    add_index :steps, [:trail_id, :position]
  end
end
