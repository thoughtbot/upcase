require "administrate/base_dashboard"

class FlashcardDashboard < Administrate::BaseDashboard
  READ_ONLY_ATTRIBUTES = [
    :id,
    :created_at,
    :updated_at,
  ]

  ATTRIBUTE_TYPES = {
    deck: Field::BelongsTo,
    attempts: Field::HasMany,
    id: Field::Number,
    prompt: Field::String,
    answer: Field::String,
    position: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    title: Field::String,
  }

  TABLE_ATTRIBUTES = ATTRIBUTE_TYPES.keys.first(4)

  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  FORM_ATTRIBUTES = ATTRIBUTE_TYPES.keys - READ_ONLY_ATTRIBUTES
end
