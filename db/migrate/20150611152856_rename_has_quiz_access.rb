class RenameHasQuizAccess < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :has_quiz_access, :has_deck_access
  end
end
