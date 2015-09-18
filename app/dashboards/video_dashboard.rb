require "administrate/base_dashboard"

class VideoDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    watchable: Field::Polymorphic,
    classifications: Field::HasMany,
    markers: Field::HasMany,
    statuses: Field::HasMany,
    teachers: Field::HasMany,
    topics: Field::HasMany,
    users: Field::HasMany,
    step: Field::HasOne,
    trail: Field::HasOne,
    id: Field::Number,
    wistia_id: Field::String,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    position: Field::Number,
    notes: Field::String,
    published_on: Field::DateTime,
    preview_wistia_id: Field::String,
    slug: Field::String,
    summary: Field::String,
  }

  TABLE_ATTRIBUTES = [
    :id,
    :watchable,
    :name,
    :created_at,
  ]

  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  FORM_ATTRIBUTES = [
    :name,
    :slug,
    :summary,
    :notes,
    :topics,

    :watchable,

    :position,
    :published_on,
    :users,
    :markers,

    :wistia_id,
    :preview_wistia_id,
  ]
end
