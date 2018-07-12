class RenameTumblrUrlToExternalUrl < ActiveRecord::Migration[4.2]
  def up
    rename_column :articles, :tumblr_url, :external_url
  end

  def down
    rename_column :articles, :external_url, :tumblr_url
  end
end
