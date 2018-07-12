class RemoveIncludesScreencastsFromPlans < ActiveRecord::Migration[4.2]
  def change
    remove_column :plans, :includes_screencasts, :boolean
  end
end
