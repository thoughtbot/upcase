class ChangeTopicsAddNullCols < ActiveRecord::Migration
  def up
    change_column :topics, :body_html, :text, null: true
  end

  def down
    change_column :topics, :body_html, :text, null: false
  end
end
