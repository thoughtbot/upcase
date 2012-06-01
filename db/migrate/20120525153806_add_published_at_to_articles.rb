class AddPublishedAtToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :published_at, :date, null: false
  end
end
