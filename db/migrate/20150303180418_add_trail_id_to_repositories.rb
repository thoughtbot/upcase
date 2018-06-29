class AddTrailIdToRepositories < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :trail_id, :integer
    add_index :products, :trail_id
  end
end
