require "administrate/base_dashboard"

class SubscriptionDashboard < Administrate::BaseDashboard
  READ_ONLY_ATTRIBUTES = [
    :id,
    :created_at,
    :updated_at,
  ]

  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    plan: Field::Polymorphic,
    team: Field::HasOne,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    deactivated_on: Field::DateTime,
    scheduled_for_deactivation_on: Field::DateTime,
    next_payment_amount: Field::String,
    next_payment_on: Field::DateTime,
    stripe_id: Field::String,
    user_clicked_cancel_button_on: Field::DateTime,
  }

  TABLE_ATTRIBUTES = ATTRIBUTE_TYPES.keys.first(4)

  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  FORM_ATTRIBUTES = ATTRIBUTE_TYPES.keys - READ_ONLY_ATTRIBUTES
end
