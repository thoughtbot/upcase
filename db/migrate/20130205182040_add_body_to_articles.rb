class AddBodyToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :body, :text
  end
end
