class RemoveTopicFromTrails < ActiveRecord::Migration
  def up
    remove_column :trails, :topic_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
