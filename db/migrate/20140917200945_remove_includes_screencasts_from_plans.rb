class RemoveIncludesScreencastsFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :includes_screencasts, :boolean
  end
end
