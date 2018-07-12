class ChangeTopicsAddNullCols < ActiveRecord::Migration[4.2]
  def up
    change_column :topics, :body_html, :text, null: true
  end

  def down
    change_column :topics, :body_html, :text, null: false
  end
end
