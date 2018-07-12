class AddDraftToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :draft, :boolean, default: false, null: false
  end
end
