class MoveScreencastsIntoProducts < ActiveRecord::Migration
  def up
    say_with_time "Converting screencasts into video_tutorials" do
      update "UPDATE products SET type = 'VideoTutorial' WHERE type = 'Screencast'"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
