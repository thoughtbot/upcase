class ChangeTrailsTopicIdToNotNull < ActiveRecord::Migration[4.2]
  def up
    change_column_null :trails, :topic_id, false
  end

  def down
    change_column_null :trails, :topic_id, true
  end
end
