class AddStatusIndexes < ActiveRecord::Migration
  def change
    add_index :statuses, :exercise_id
    add_index :statuses, :user_id
  end
end
