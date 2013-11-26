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

ActiveRecord::Schema.define(version: 20131125202014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", force: true do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "announceable_id",   null: false
    t.string   "announceable_type", null: false
    t.text     "message",           null: false
    t.datetime "ends_at",           null: false
  end

  add_index "announcements", ["announceable_id", "announceable_type", "ends_at"], name: "index_announcements_on_announceable_and_ends_at", using: :btree

  create_table "classifications", force: true do |t|
    t.integer  "topic_id"
    t.string   "classifiable_type"
    t.integer  "classifiable_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

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

  create_table "coupons", force: true do |t|
    t.string   "code"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",            default: true,         null: false
    t.string   "discount_type",     default: "percentage", null: false
    t.boolean  "one_time_use_only", default: false,        null: false
  end

  add_index "coupons", ["code"], name: "index_coupons_on_code", using: :btree

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

  create_table "follow_ups", force: true do |t|
    t.string   "email"
    t.integer  "workshop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "notified_at"
  end

  add_index "follow_ups", ["workshop_id"], name: "index_follow_ups_on_workshop_id", using: :btree

  create_table "individual_plans", force: true do |t|
    t.string   "name",                              null: false
    t.string   "sku",                               null: false
    t.string   "short_description",                 null: false
    t.text     "description",                       null: false
    t.boolean  "active",             default: true, null: false
    t.integer  "individual_price",                  null: false
    t.text     "terms"
    t.boolean  "includes_mentor",    default: true
    t.boolean  "includes_workshops", default: true
    t.boolean  "featured",           default: true, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "notes", force: true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "contributor_id", null: false
  end

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
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.string   "redirect_uri", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "sku"
    t.string   "tagline"
    t.string   "call_to_action"
    t.string   "short_description"
    t.text     "description"
    t.integer  "individual_price",           default: 0,    null: false
    t.integer  "company_price",              default: 0,    null: false
    t.string   "product_type"
    t.boolean  "active",                     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fulfillment_method"
    t.integer  "github_team"
    t.string   "github_url"
    t.text     "questions"
    t.text     "terms"
    t.text     "alternative_description"
    t.string   "product_image_file_name"
    t.string   "product_image_file_size"
    t.string   "product_image_content_type"
    t.string   "product_image_updated_at"
    t.integer  "discount_percentage",        default: 0,    null: false
    t.string   "discount_title",             default: "",   null: false
  end

  create_table "purchases", force: true do |t|
    t.string   "stripe_customer_id"
    t.string   "variant"
    t.string   "name"
    t.string   "email"
    t.string   "organization"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lookup"
    t.integer  "coupon_id"
    t.text     "github_usernames"
    t.boolean  "paid",                   default: false,    null: false
    t.string   "payment_method",         default: "stripe", null: false
    t.string   "country"
    t.string   "payment_transaction_id"
    t.integer  "user_id"
    t.decimal  "paid_price"
    t.integer  "purchaseable_id"
    t.string   "purchaseable_type"
    t.text     "comments"
    t.string   "stripe_coupon_id"
    t.integer  "quantity",               default: 1,        null: false
  end

  add_index "purchases", ["lookup"], name: "index_purchases_on_lookup", using: :btree
  add_index "purchases", ["stripe_customer_id"], name: "index_purchases_on_stripe_customer", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "workshop_id"
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["workshop_id"], name: "index_questions_on_workshop_id", using: :btree

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

  create_table "resources", force: true do |t|
    t.integer "course_id"
    t.string  "name"
    t.string  "url"
  end

  add_index "resources", ["course_id"], name: "index_resources_on_course_id", using: :btree

  create_table "section_teachers", force: true do |t|
    t.integer  "section_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "section_teachers", ["section_id", "teacher_id"], name: "index_section_teachers_on_section_id_and_teacher_id", unique: true, using: :btree

  create_table "sections", force: true do |t|
    t.integer  "workshop_id"
    t.date     "starts_on"
    t.date     "ends_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seats_available"
    t.time     "start_at"
    t.time     "stop_at"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
  end

  add_index "sections", ["workshop_id"], name: "index_sections_on_workshop_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.date     "deactivated_on"
    t.date     "scheduled_for_cancellation_on"
    t.boolean  "paid",                          default: true,             null: false
    t.integer  "plan_id",                                                  null: false
    t.integer  "team_id"
    t.string   "plan_type",                     default: "IndividualPlan", null: false
  end

  add_index "subscriptions", ["plan_id", "plan_type"], name: "index_subscriptions_on_plan_id_and_plan_type", using: :btree
  add_index "subscriptions", ["team_id"], name: "index_subscriptions_on_team_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "teachers", force: true do |t|
    t.string   "name"
    t.string   "gravatar_hash"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "team_plans", force: true do |t|
    t.string   "sku",                               null: false
    t.string   "name",                              null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "individual_price"
    t.text     "terms"
    t.boolean  "includes_mentor",    default: true, null: false
    t.boolean  "includes_workshops", default: true, null: false
    t.boolean  "featured",           default: true, null: false
    t.text     "description"
  end

  create_table "teams", force: true do |t|
    t.string   "name",         null: false
    t.integer  "team_plan_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "topics", force: true do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "keywords"
    t.string   "name",                       null: false
    t.string   "slug",                       null: false
    t.text     "summary"
    t.integer  "count"
    t.boolean  "featured",   default: false, null: false
  end

  add_index "topics", ["slug"], name: "index_topics_on_slug", unique: true, using: :btree

  create_table "trails", force: true do |t|
    t.integer  "topic_id"
    t.string   "slug"
    t.text     "trail_map"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "trails", ["topic_id"], name: "index_trails_on_topic_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",  limit: 128
    t.string   "salt",                limit: 128
    t.string   "confirmation_token",  limit: 128
    t.string   "remember_token",      limit: 128
    t.boolean  "email_confirmed",                 default: true,                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_id"
    t.string   "reference"
    t.boolean  "admin",                           default: false,                    null: false
    t.string   "stripe_customer_id"
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
    t.boolean  "available_to_mentor",             default: false
    t.text     "bio"
    t.integer  "mentor_id"
    t.string   "availability",                    default: "11am to 5pm on Fridays", null: false
  end

  add_index "users", ["admin"], name: "index_users_on_admin", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["id", "confirmation_token"], name: "index_users_on_id_and_confirmation_token", using: :btree
  add_index "users", ["mentor_id"], name: "index_users_on_mentor_id", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "videos", force: true do |t|
    t.integer  "watchable_id"
    t.string   "wistia_id"
    t.string   "title"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "watchable_type"
    t.integer  "position",       default: 0, null: false
    t.text     "notes"
  end

  add_index "videos", ["watchable_type", "watchable_id"], name: "index_videos_on_watchable_type_and_watchable_id", using: :btree

  create_table "workshops", force: true do |t|
    t.string   "name",                                      null: false
    t.text     "description"
    t.integer  "maximum_students"
    t.boolean  "active",                    default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_description"
    t.string   "external_registration_url"
    t.integer  "position"
    t.text     "terms"
    t.boolean  "online",                    default: false, null: false
    t.text     "resources",                 default: "",    null: false
    t.string   "video_chat_url"
    t.integer  "github_team"
    t.integer  "length_in_days"
    t.string   "office_hours",              default: "",    null: false
    t.string   "sku"
  end

end
