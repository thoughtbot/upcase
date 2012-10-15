class RenameTopicBodyHtmlToTrailMap < ActiveRecord::Migration
  def up
    rename_column :topics, :body_html, :trail_map
  end

  def down
    rename_column :topics, :trail_map, :body_html
  end
end
