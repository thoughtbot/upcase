require "administrate/base_dashboard"

class TrailDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    topic: Field::BelongsTo,
    repositories: Field::HasMany,
    statuses: Field::HasMany,
    users: Field::HasMany,
    steps: Field::HasMany,
    exercises: Field::HasMany,
    videos: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    complete_text: Field::String,
    published: Field::Boolean,
    slug: Field::String,
    description: Field::String,
  }

  TABLE_ATTRIBUTES = [
    :id,
    :name,
    :published,
  ]

  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  FORM_ATTRIBUTES = ATTRIBUTE_TYPES.keys - [
    :exercises,
    :videos,
    :statuses,
    :users,
  ]
end
