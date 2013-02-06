class AddBodyToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :body, :text
  end
end
