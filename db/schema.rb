# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150108220013) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "checkouts", force: true do |t|
    t.integer  "user_id",                      null: false
    t.integer  "plan_id",                      null: false
    t.integer  "quantity",         default: 1, null: false
    t.string   "stripe_coupon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkouts", ["user_id"], name: "index_checkouts_on_user_id", using: :btree

  create_table "classifications", force: true do |t|
    t.integer  "topic_id"
    t.string   "classifiable_type"
    t.integer  "classifiable_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "collaborations", force: true do |t|
    t.integer  "repository_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "collaborations", ["repository_id", "user_id"], name: "index_collaborations_on_repository_id_and_user_id", unique: true, using: :btree

  create_table "completions", force: true do |t|
    t.string   "trail_object_id"
    t.string   "trail_name"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "slug"
  end

  add_index "completions", ["trail_object_id"], name: "index_completions_on_trail_object_id", using: :btree
  add_index "completions", ["user_id"], name: "index_completions_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "downloads", force: true do |t|
    t.integer  "purchaseable_id"
    t.string   "download_file_name"
    t.string   "download_file_size"
    t.string   "download_content_type"
    t.string   "download_updated_at"
    t.string   "description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "purchaseable_type"
  end

  create_table "exercises", force: true do |t|
    t.string   "title",                      null: false
    t.string   "url",                        null: false
    t.text     "summary",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid",                       null: false
    t.boolean  "public",     default: false, null: false
    t.string   "edit_url"
  end

  add_index "exercises", ["public"], name: "index_exercises_on_public", using: :btree
  add_index "exercises", ["uuid"], name: "index_exercises_on_uuid", unique: true, using: :btree

  create_table "invitations", force: true do |t|
    t.string   "email",        null: false
    t.string   "code",         null: false
    t.datetime "accepted_at"
    t.integer  "sender_id",    null: false
    t.integer  "recipient_id"
    t.integer  "team_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "invitations", ["code"], name: "index_invitations_on_code", using: :btree
  add_index "invitations", ["team_id"], name: "index_invitations_on_team_id", using: :btree

  create_table "legacy_trails", force: true do |t|
    t.integer  "topic_id"
    t.string   "slug"
    t.text     "trail_map"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "legacy_trails", ["topic_id"], name: "index_legacy_trails_on_topic_id", using: :btree

  create_table "mentors", force: true do |t|
    t.integer "user_id",                                                  null: false
    t.string  "availability",          default: "11am to 5pm on Fridays", null: false
    t.boolean "accepting_new_mentees", default: true,                     null: false
  end

  add_index "mentors", ["user_id"], name: "index_mentors_on_user_id", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.string   "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.string   "redirect_uri",              null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "scopes",       default: "", null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "plans", force: true do |t|
    t.string   "name",                                     null: false
    t.string   "sku",                                      null: false
    t.string   "short_description",                        null: false
    t.text     "description",                              null: false
    t.boolean  "active",                   default: true,  null: false
    t.integer  "individual_price",                         null: false
    t.text     "terms"
    t.boolean  "includes_mentor",          default: false
    t.boolean  "includes_video_tutorials", default: true
    t.boolean  "featured",                 default: true,  null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "includes_exercises",       default: true,  null: false
    t.boolean  "includes_repositories",    default: true,  null: false
    t.boolean  "includes_forum",           default: true,  null: false
    t.boolean  "includes_shows",           default: true,  null: false
    t.boolean  "includes_team",            default: false, null: false
    t.boolean  "annual",                   default: false
    t.integer  "annual_plan_id"
  end

  add_index "plans", ["annual_plan_id"], name: "index_plans_on_annual_plan_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "sku"
    t.string   "tagline"
    t.string   "call_to_action"
    t.string   "short_description"
    t.text     "description"
    t.integer  "individual_price",           default: 0,     null: false
    t.integer  "company_price",              default: 0,     null: false
    t.string   "type",                                       null: false
    t.boolean  "active",                     default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "github_team"
    t.string   "github_url"
    t.text     "questions"
    t.text     "terms"
    t.text     "alternative_description"
    t.string   "product_image_file_name"
    t.string   "product_image_file_size"
    t.string   "product_image_content_type"
    t.string   "product_image_updated_at"
    t.boolean  "promoted",                   default: false, null: false
    t.string   "slug",                                       null: false
    t.integer  "length_in_days"
    t.text     "resources",                  default: "",    null: false
  end

  add_index "products", ["slug"], name: "index_products_on_slug", unique: true, using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "statuses", force: true do |t|
    t.integer  "completeable_id",                           null: false
    t.integer  "user_id",                                   null: false
    t.string   "state",             default: "In Progress", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "completeable_type",                         null: false
  end

  add_index "statuses", ["completeable_id"], name: "index_statuses_on_completeable_id", using: :btree
  add_index "statuses", ["completeable_type"], name: "index_statuses_on_completeable_type", using: :btree
  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id", using: :btree

  create_table "steps", force: true do |t|
    t.integer  "trail_id",    null: false
    t.integer  "exercise_id", null: false
    t.integer  "position",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "steps", ["trail_id", "position"], name: "index_steps_on_trail_id_and_position", using: :btree
  add_index "steps", ["trail_id"], name: "index_steps_on_trail_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.date     "deactivated_on"
    t.date     "scheduled_for_cancellation_on"
    t.integer  "plan_id",                                                  null: false
    t.string   "plan_type",                     default: "IndividualPlan", null: false
    t.decimal  "next_payment_amount",           default: 0.0,              null: false
    t.date     "next_payment_on"
    t.string   "stripe_id"
  end

  add_index "subscriptions", ["plan_id", "plan_type"], name: "index_subscriptions_on_plan_id_and_plan_type", using: :btree
  add_index "subscriptions", ["stripe_id"], name: "index_subscriptions_on_stripe_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "teachers", force: true do |t|
    t.integer "user_id"
    t.integer "video_tutorial_id"
  end

  add_index "teachers", ["user_id", "video_tutorial_id"], name: "index_teachers_on_user_id_and_video_tutorial_id", unique: true, using: :btree

  create_table "teams", force: true do |t|
    t.string   "name",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "subscription_id", null: false
  end

  create_table "topics", force: true do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "keywords"
    t.string   "name",                         null: false
    t.string   "slug",                         null: false
    t.text     "summary"
    t.integer  "count"
    t.boolean  "featured",     default: false, null: false
    t.boolean  "explorable",   default: false, null: false
    t.string   "color",        default: "",    null: false
    t.string   "color_accent", default: "",    null: false
  end

  add_index "topics", ["explorable"], name: "index_topics_on_explorable", using: :btree
  add_index "topics", ["slug"], name: "index_topics_on_slug", unique: true, using: :btree

  create_table "trails", force: true do |t|
    t.string   "name",                          null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "complete_text",                 null: false
    t.boolean  "published",     default: false, null: false
    t.string   "slug",                          null: false
    t.text     "description",   default: "",    null: false
    t.integer  "topic_id"
  end

  add_index "trails", ["published"], name: "index_trails_on_published", using: :btree
  add_index "trails", ["slug"], name: "index_trails_on_slug", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password", limit: 128
    t.string   "salt",               limit: 128
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128
    t.boolean  "email_confirmed",                default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference"
    t.boolean  "admin",                          default: false, null: false
    t.string   "stripe_customer_id",             default: "",    null: false
    t.string   "github_username"
    t.string   "auth_provider"
    t.integer  "auth_uid"
    t.string   "organization"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.string   "name"
    t.text     "bio"
    t.integer  "mentor_id"
    t.integer  "team_id"
  end

  add_index "users", ["admin"], name: "index_users_on_admin", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["github_username"], name: "index_users_on_github_username", unique: true, using: :btree
  add_index "users", ["id", "confirmation_token"], name: "index_users_on_id_and_confirmation_token", using: :btree
  add_index "users", ["mentor_id"], name: "index_users_on_mentor_id", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

  create_table "videos", force: true do |t|
    t.integer  "watchable_id"
    t.string   "wistia_id"
    t.string   "title"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "watchable_type"
    t.integer  "position",          default: 0, null: false
    t.text     "notes"
    t.date     "published_on"
    t.string   "preview_wistia_id"
    t.string   "slug",                          null: false
  end

  add_index "videos", ["slug"], name: "index_videos_on_slug", unique: true, using: :btree
  add_index "videos", ["watchable_type", "watchable_id"], name: "index_videos_on_watchable_type_and_watchable_id", using: :btree

end
