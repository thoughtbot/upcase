class RenameArticlesBodyToBodyHtml < ActiveRecord::Migration[4.2]
  def change
    rename_column :articles, :body, :body_html
  end
end
