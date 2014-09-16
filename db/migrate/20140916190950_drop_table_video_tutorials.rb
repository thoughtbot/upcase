class DropTableVideoTutorials < ActiveRecord::Migration
  def up
    drop_table :video_tutorials
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
