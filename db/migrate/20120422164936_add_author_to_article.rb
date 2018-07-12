class AddAuthorToArticle < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :author_id, :integer, null: false
    add_index :articles, :author_id
  end
end
