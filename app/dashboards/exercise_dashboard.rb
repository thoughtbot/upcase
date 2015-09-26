require "administrate/base_dashboard"

class ExerciseDashboard < Administrate::BaseDashboard
  READ_ONLY_ATTRIBUTES = [
    :id,
    :created_at,
    :updated_at,
  ]

  ATTRIBUTE_TYPES = {
    statuses: Field::HasMany,
    trail: Field::HasOne,
    step: Field::HasOne,
    id: Field::Number,
    name: Field::String,
    url: Field::String,
    summary: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    uuid: Field::String,
    edit_url: Field::String,
  }

  TABLE_ATTRIBUTES = [
    :id,
    :name,
  ]

  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  FORM_ATTRIBUTES = [:trail]
end
