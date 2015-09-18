require "administrate/base_dashboard"

class ProductDashboard < Administrate::BaseDashboard
  READ_ONLY_ATTRIBUTES = [
    :id,
    :created_at,
    :updated_at,
  ]

  ATTRIBUTE_TYPES = {
    classifications: Field::HasMany,
    topics: Field::HasMany,
    videos: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    sku: Field::String,
    tagline: Field::String,
    call_to_action: Field::String,
    short_description: Field::String,
    description: Field::String,
    type: Field::String,
    active: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    github_url: Field::String,
    questions: Field::String,
    terms: Field::String,
    alternative_description: Field::String,
    product_image_file_name: Field::String,
    product_image_file_size: Field::String,
    product_image_content_type: Field::String,
    product_image_updated_at: Field::String,
    promoted: Field::Boolean,
    slug: Field::String,
    resources: Field::String,
    github_repository: Field::String,
    trail_id: Field::Number,
  }

  TABLE_ATTRIBUTES = [
    :id,
    :name,
    :sku,
    :type,
  ]

  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  FORM_ATTRIBUTES = ATTRIBUTE_TYPES.keys - READ_ONLY_ATTRIBUTES
end
