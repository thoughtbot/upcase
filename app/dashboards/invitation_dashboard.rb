require "administrate/base_dashboard"

class InvitationDashboard < Administrate::BaseDashboard
  READ_ONLY_ATTRIBUTES = [
    :id,
    :created_at,
    :updated_at,
  ]

  ATTRIBUTE_TYPES = {
    id: Field::Number,
    recipient: Field::BelongsTo.with_options(class_name: "User"),
    sender: Field::BelongsTo.with_options(class_name: "User"),
    team: Field::BelongsTo,
    email: Field::String,
    code: Field::String,
    accepted_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  TABLE_ATTRIBUTES = ATTRIBUTE_TYPES.keys.first(4)

  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  FORM_ATTRIBUTES = ATTRIBUTE_TYPES.keys - READ_ONLY_ATTRIBUTES
end
