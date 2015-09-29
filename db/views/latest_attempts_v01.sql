SELECT DISTINCT ON (user_id, flashcard_id) *
FROM attempts
ORDER BY user_id, flashcard_id, updated_at DESC
