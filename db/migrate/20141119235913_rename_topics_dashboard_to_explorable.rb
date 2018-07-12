class RenameTopicsDashboardToExplorable < ActiveRecord::Migration[4.2]
  def change
    rename_column :topics, :dashboard, :explorable
  end
end
