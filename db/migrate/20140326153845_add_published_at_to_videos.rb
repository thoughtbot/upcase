class AddPublishedAtToVideos < ActiveRecord::Migration
  def up
    add_column :videos, :published_at, :datetime
    execute <<-SQL
      UPDATE videos
      SET published_at = created_at
    SQL
  end

  def down
    remove_column :videos, :published_at
  end
end
