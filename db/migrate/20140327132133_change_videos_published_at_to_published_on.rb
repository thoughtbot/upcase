class ChangeVideosPublishedAtToPublishedOn < ActiveRecord::Migration
  def up
    rename_column :videos, :published_at, :published_on
    change_column :videos, :published_on, :date
  end

  def down
    rename_column :videos, :published_on, :published_at
    change_column :videos, :published_at, :datetime
  end
end
