class AddStatusIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :statuses, :exercise_id
    add_index :statuses, :user_id
  end
end
