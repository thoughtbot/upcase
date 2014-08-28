class AddDashboardToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :dashboard, :boolean, null: false, default: false
    add_index :topics, :dashboard
    update "UPDATE topics SET dashboard=featured"
  end
end
