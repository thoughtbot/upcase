class AddPositionIndex < ActiveRecord::Migration[4.2]
  def change
    add_index :steps, [:trail_id, :position]
  end
end
