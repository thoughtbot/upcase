class RemoveUniqueIndexFromStatuses < ActiveRecord::Migration[4.2]
  def change
    remove_index :statuses, name: :index_statuses_on_exercise_id_and_user_id
  end
end
