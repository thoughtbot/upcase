class ArticlesTumblrUrlAllowsNil < ActiveRecord::Migration
  def up
    change_column :articles, :tumblr_url, :string, null: true
  end

  def down
    change_column :articles, :tumblr_url, :string, null: false
  end
end
