require "administrate/base_dashboard"

class MentorDashboard < Administrate::BaseDashboard
  READ_ONLY_ATTRIBUTES = [
    :id,
    :created_at,
    :updated_at,
  ]

  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    mentees: Field::HasMany.with_options(class_name: "User"),
    id: Field::Number,
    availability: Field::String,
    accepting_new_mentees: Field::Boolean,
    active_mentees: Field::HasMany.with_options(class_name: "User"),
  }

  TABLE_ATTRIBUTES = [
    :user,
    :accepting_new_mentees,
    :active_mentees,
    :availability,
  ]

  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :accepting_new_mentees,
    :availability,
  ]

  FORM_ATTRIBUTES = [
    :user,
    :accepting_new_mentees,
    :availability,
  ]
end
