class RemoveTopicFromTrails < ActiveRecord::Migration
  def change
    remove_column :trails, :topic_id
  end
end
