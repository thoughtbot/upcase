class AddPublishedAtToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :published_at, :date, null: false
  end
end
