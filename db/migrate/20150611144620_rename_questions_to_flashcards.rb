class RenameQuestionsToFlashcards < ActiveRecord::Migration
  def change
    rename_table :questions, :flashcards
    rename_column :attempts, :question_id, :flashcard_id
  end
end
