class RenameArticlesBodyToBodyHtml < ActiveRecord::Migration
  def change
    rename_column :articles, :body, :body_html
  end
end
