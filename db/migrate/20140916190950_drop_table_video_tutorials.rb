class DropTableVideoTutorials < ActiveRecord::Migration[4.2]
  def up
    drop_table :video_tutorials
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
