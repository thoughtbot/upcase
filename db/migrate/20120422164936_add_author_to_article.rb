class AddAuthorToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :author_id, :integer, null: false
    add_index :articles, :author_id
  end
end
