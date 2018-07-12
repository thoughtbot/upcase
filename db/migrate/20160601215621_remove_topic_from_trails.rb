class RemoveTopicFromTrails < ActiveRecord::Migration[4.2]
  def up
    remove_column :trails, :topic_id
  end

  def down
    raise(
      ActiveRecord::IrreversibleMigration,
      "Can't turn multiple associated topics back into one topic",
    )
  end
end
