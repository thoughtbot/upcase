class AdjustArticlesAndBytesAllowedNulls < ActiveRecord::Migration
  def up
    change_column_null :articles, :external_url, false
    change_column_null :bytes, :body, false
  end

  def down
    change_column_null :articles, :external_url, true
    change_column_null :bytes, :body, true
  end
end
