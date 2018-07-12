class RenameTopicBodyHtmlToTrailMap < ActiveRecord::Migration[4.2]
  def up
    remove_column :topics, :body_html
    add_column :topics, :trail_map, :text
  end

  def down
    remove_column :topics, :trail_map
    add_column :topics, :body_html, :text
  end
end
