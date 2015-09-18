require "administrate/base_dashboard"

class TopicDashboard < Administrate::BaseDashboard
  READ_ONLY_ATTRIBUTES = [
    :id,
    :created_at,
    :updated_at,
  ]

  ATTRIBUTE_TYPES = {
    classifications: Field::HasMany,
    products: Field::HasMany,
    topics: Field::HasMany,
    videos: Field::HasMany,
    trails: Field::HasMany,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    keywords: Field::String,
    name: Field::String,
    slug: Field::String,
    summary: Field::String,
    explorable: Field::Boolean,
    color: Field::String,
    color_accent: Field::String,
  }

  TABLE_ATTRIBUTES = ATTRIBUTE_TYPES.keys.first(4)

  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  FORM_ATTRIBUTES = ATTRIBUTE_TYPES.keys - READ_ONLY_ATTRIBUTES
end
