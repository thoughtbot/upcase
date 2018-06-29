class AddTopicIdToTrails < ActiveRecord::Migration[4.2]
  def change
    add_column :trails, :topic_id, :integer
  end
end
