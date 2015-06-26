require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  READ_ONLY_ATTRIBUTES = [
    :id,
    :created_at,
    :updated_at,
  ]

  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    attempts: Field::HasMany,
    collaborations: Field::HasMany,
    statuses: Field::HasMany,
    subscriptions: Field::HasMany,
    mentor: Field::BelongsTo,
    team: Field::BelongsTo,
    id: Field::Number,
    email: Field::String,
    encrypted_password: Field::String,
    salt: Field::String,
    confirmation_token: Field::String,
    remember_token: Field::String,
    email_confirmed: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    reference: Field::String,
    admin: Field::Boolean,
    stripe_customer_id: Field::String,
    github_username: Field::String,
    auth_provider: Field::String,
    auth_uid: Field::Number,
    organization: Field::String,
    address1: Field::String,
    address2: Field::String,
    city: Field::String,
    state: Field::String,
    zip_code: Field::String,
    country: Field::String,
    name: Field::String,
    bio: Field::String,
    utm_source: Field::String,
    completed_welcome: Field::Boolean,
    subscription: Field::HasOne,
  }

  # TABLE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to remove the limit or customize the returned array.
  TABLE_ATTRIBUTES = [
    :id,
    :name,
    :email,
    :github_username,
    :subscription,
    # :masquerade,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :email,
    :name,
    :admin,
    :bio,
    :github_username,
    :mentor,
    :stripe_customer_id,
  ]
end
