class AddCommentsToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :comments, :text
  end
end
