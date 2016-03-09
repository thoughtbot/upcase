SELECT DISTINCT ON (attempts.user_id, flashcards.deck_id) attempts.*, flashcards.deck_id
FROM attempts INNER JOIN flashcards ON flashcards.id = attempts.flashcard_id
ORDER BY attempts.user_id, flashcards.deck_id, attempts.updated_at DESC
