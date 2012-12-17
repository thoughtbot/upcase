class AddCommentsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :comments, :text
  end
end
