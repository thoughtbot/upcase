class RenameTopicsBodyToBodyHtml < ActiveRecord::Migration[4.2]
  def change
    rename_column :topics, :body, :body_html
  end
end
