class RenameTopicsDashboardToExplorable < ActiveRecord::Migration
  def change
    rename_column :topics, :dashboard, :explorable
  end
end
