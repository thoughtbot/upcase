class AddFlashcardsCountToDecks < ActiveRecord::Migration[4.2]
  def up
    add_column :decks, :flashcards_count, :integer, default: 0

    execute <<-SQL
      UPDATE decks SET flashcards_count = (
        SELECT COUNT(*) FROM flashcards WHERE deck_id = decks.id
      )
    SQL
  end

  def down
    remove_column :decks, :flashcards_count
  end
end
