class RenameTopicsBodyToBodyHtml < ActiveRecord::Migration
  def change
    rename_column :topics, :body, :body_html
  end
end
