class AddDashboardToTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :topics, :dashboard, :boolean, null: false, default: false
    add_index :topics, :dashboard
    update "UPDATE topics SET dashboard=featured"
  end
end
