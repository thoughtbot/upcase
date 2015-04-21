class ChangeTrailsTopicIdToNotNull < ActiveRecord::Migration
  def up
    change_column_null :trails, :topic_id, false
  end

  def down
    change_column_null :trails, :topic_id, true
  end
end
