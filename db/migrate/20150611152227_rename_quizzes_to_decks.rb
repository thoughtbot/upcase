class RenameQuizzesToDecks < ActiveRecord::Migration[4.2]
  def change
    rename_table :quizzes, :decks

    rename_column :flashcards, :quiz_id, :deck_id
  end
end
