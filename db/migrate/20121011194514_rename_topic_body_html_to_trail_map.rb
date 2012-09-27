class RenameTopicBodyHtmlToTrailMap < ActiveRecord::Migration
  def up
    remove_column :topics, :body_html
    add_column :topics, :trail_map, :text
  end

  def down
    remove_column :topics, :trail_map
    add_column :topics, :body_html, :text
  end
end
