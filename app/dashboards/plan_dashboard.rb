require "administrate/base_dashboard"

class PlanDashboard < Administrate::BaseDashboard
  READ_ONLY_ATTRIBUTES = [
    :id,
    :created_at,
    :updated_at,
  ]

  ATTRIBUTE_TYPES = {
    checkouts: Field::HasMany,
    subscriptions: Field::HasMany,
    annual_plan: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    sku: Field::String,
    short_description: Field::String,
    description: Field::String,
    active: Field::Boolean,
    price_in_dollars: Field::Number,
    terms: Field::String,
    includes_mentor: Field::Boolean,
    featured: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    includes_repositories: Field::Boolean,
    includes_forum: Field::Boolean,
    includes_shows: Field::Boolean,
    includes_team: Field::Boolean,
    annual: Field::Boolean,
    minimum_quantity: Field::Number,
    includes_trails: Field::Boolean,
  }

  TABLE_ATTRIBUTES = ATTRIBUTE_TYPES.keys.first(4)

  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  FORM_ATTRIBUTES = ATTRIBUTE_TYPES.keys - READ_ONLY_ATTRIBUTES
end
