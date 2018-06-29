class AddHasQuizAccessToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :has_quiz_access, :boolean, null: false, default: false
  end
end
