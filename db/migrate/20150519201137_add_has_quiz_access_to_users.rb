class AddHasQuizAccessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_quiz_access, :boolean, null: false, default: false
  end
end
