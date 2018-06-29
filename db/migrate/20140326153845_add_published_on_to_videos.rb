class AddPublishedOnToVideos < ActiveRecord::Migration[4.2]
  def up
    add_column :videos, :published_on, :date
    execute <<-SQL
      UPDATE videos
      SET published_on = created_at
    SQL
  end

  def down
    remove_column :videos, :published_on
  end
end
