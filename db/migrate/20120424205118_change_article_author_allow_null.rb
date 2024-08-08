class ChangeArticleAuthorAllowNull < ActiveRecord::Migration[4.2]
  def up
    change_column :articles, :author_id, :integer, null: true
  end

  def down
    change_column :articles, :author_id, :integer, null: false
  end
end
