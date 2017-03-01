class AddPriorityToTrail < ActiveRecord::Migration
  def change
    add_column :trails, :priority, :integer
  end
end
