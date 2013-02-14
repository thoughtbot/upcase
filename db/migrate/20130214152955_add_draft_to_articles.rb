class AddDraftToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :draft, :boolean, default: false, null: false
  end
end
