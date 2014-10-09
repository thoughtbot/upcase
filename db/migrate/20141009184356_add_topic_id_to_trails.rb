class AddTopicIdToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :topic_id, :integer
  end
end
