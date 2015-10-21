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

ActiveRecord::Schema.define(version: 20151009153142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "attempts", force: :cascade do |t|
    t.integer  "confidence",   null: false
    t.integer  "flashcard_id", null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "attempts", ["flashcard_id"], name: "index_attempts_on_flashcard_id", using: :btree
  add_index "attempts", ["user_id"], name: "index_attempts_on_user_id", using: :btree

  create_table "checkouts", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.integer  "plan_id",                      null: false
    t.string   "stripe_coupon_id", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkouts", ["user_id"], name: "index_checkouts_on_user_id", using: :btree

  create_table "classifications", force: :cascade do |t|
    t.integer  "topic_id"
    t.string   "classifiable_type", limit: 255
    t.integer  "classifiable_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "collaborations", force: :cascade do |t|
    t.integer  "repository_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "collaborations", ["repository_id", "user_id"], name: "index_collaborations_on_repository_id_and_user_id", unique: true, using: :btree

  create_table "decks", force: :cascade do |t|
    t.string   "title",                            null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "published",        default: false, null: false
    t.integer  "flashcards_count", default: 0
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0
    t.integer  "attempts",               default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "exercises", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "url",        limit: 255, null: false
    t.text     "summary",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid",       limit: 255, null: false
    t.string   "edit_url",   limit: 255
  end

  add_index "exercises", ["uuid"], name: "index_exercises_on_uuid", unique: true, using: :btree

  create_table "flashcards", force: :cascade do |t|
    t.text     "prompt",     null: false
    t.text     "answer",     null: false
    t.integer  "position",   null: false
    t.integer  "deck_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title",      null: false
  end

  add_index "flashcards", ["deck_id"], name: "index_flashcards_on_deck_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string   "email",        limit: 255, null: false
    t.string   "code",         limit: 255, null: false
    t.datetime "accepted_at"
    t.integer  "sender_id",                null: false
    t.integer  "recipient_id"
    t.integer  "team_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "invitations", ["code"], name: "index_invitations_on_code", using: :btree
  add_index "invitations", ["team_id"], name: "index_invitations_on_team_id", using: :btree

  create_table "markers", force: :cascade do |t|
    t.string   "anchor",     null: false
    t.integer  "time",       null: false
    t.integer  "video_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "markers", ["video_id"], name: "index_markers_on_video_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id",             null: false
    t.integer  "application_id",                null: false
    t.string   "token",             limit: 255, null: false
    t.integer  "expires_in",                    null: false
    t.string   "redirect_uri",      limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",                null: false
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,              null: false
    t.string   "uid",          limit: 255,              null: false
    t.string   "secret",       limit: 255,              null: false
    t.string   "redirect_uri", limit: 255,              null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "scopes",       limit: 255, default: "", null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",                  limit: 255,                 null: false
    t.string   "sku",                   limit: 255,                 null: false
    t.string   "short_description",     limit: 255,                 null: false
    t.text     "description",                                       null: false
    t.boolean  "active",                            default: true,  null: false
    t.integer  "price_in_dollars",                                  null: false
    t.text     "terms"
    t.boolean  "featured",                          default: false, null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "includes_repositories",             default: true,  null: false
    t.boolean  "includes_forum",                    default: true,  null: false
    t.boolean  "includes_shows",                    default: true,  null: false
    t.boolean  "includes_team",                     default: false, null: false
    t.boolean  "annual",                            default: false
    t.integer  "annual_plan_id"
    t.integer  "minimum_quantity",                  default: 1,     null: false
    t.boolean  "includes_trails",                   default: false, null: false
  end

  add_index "plans", ["annual_plan_id"], name: "index_plans_on_annual_plan_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "sku",                        limit: 255
    t.string   "tagline",                    limit: 255
    t.string   "call_to_action",             limit: 255
    t.string   "short_description",          limit: 255
    t.text     "description"
    t.string   "type",                       limit: 255,                 null: false
    t.boolean  "active",                                 default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "github_url",                 limit: 255
    t.text     "questions"
    t.text     "terms"
    t.text     "alternative_description"
    t.string   "product_image_file_name",    limit: 255
    t.string   "product_image_file_size",    limit: 255
    t.string   "product_image_content_type", limit: 255
    t.string   "product_image_updated_at",   limit: 255
    t.boolean  "promoted",                               default: false, null: false
    t.string   "slug",                       limit: 255,                 null: false
    t.text     "resources",                              default: "",    null: false
    t.string   "github_repository"
    t.integer  "trail_id"
  end

  add_index "products", ["slug"], name: "index_products_on_slug", unique: true, using: :btree
  add_index "products", ["trail_id"], name: "index_products_on_trail_id", using: :btree

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message"
    t.string   "username",   limit: 255
    t.integer  "item"
    t.string   "table",      limit: 255
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.integer  "completeable_id",                                       null: false
    t.integer  "user_id",                                               null: false
    t.string   "state",             limit: 255, default: "In Progress", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "completeable_type", limit: 255,                         null: false
  end

  add_index "statuses", ["completeable_id"], name: "index_statuses_on_completeable_id", using: :btree
  add_index "statuses", ["completeable_type"], name: "index_statuses_on_completeable_type", using: :btree
  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id", using: :btree

  create_table "steps", force: :cascade do |t|
    t.integer  "trail_id",          null: false
    t.integer  "completeable_id",   null: false
    t.integer  "position",          null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "completeable_type", null: false
  end

  add_index "steps", ["trail_id", "completeable_id", "completeable_type"], name: "index_steps_on_trail_and_completeable_unique", unique: true, using: :btree
  add_index "steps", ["trail_id", "position"], name: "index_steps_on_trail_id_and_position", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.date     "deactivated_on"
    t.date     "scheduled_for_deactivation_on"
    t.integer  "plan_id",                                                              null: false
    t.string   "plan_type",                     limit: 255, default: "IndividualPlan", null: false
    t.decimal  "next_payment_amount",                       default: 0.0,              null: false
    t.date     "next_payment_on"
    t.string   "stripe_id",                     limit: 255
    t.date     "user_clicked_cancel_button_on"
  end

  add_index "subscriptions", ["plan_id", "plan_type"], name: "index_subscriptions_on_plan_id_and_plan_type", using: :btree
  add_index "subscriptions", ["stripe_id"], name: "index_subscriptions_on_stripe_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "teachers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "video_id"
  end

  add_index "teachers", ["user_id", "video_id"], name: "index_teachers_on_user_id_and_video_id", unique: true, using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",            limit: 255, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "subscription_id",             null: false
  end

  create_table "topics", force: :cascade do |t|
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "keywords",   limit: 255
    t.string   "name",       limit: 255,                 null: false
    t.string   "slug",       limit: 255,                 null: false
    t.text     "summary"
    t.boolean  "explorable",             default: false, null: false
  end

  add_index "topics", ["explorable"], name: "index_topics_on_explorable", using: :btree
  add_index "topics", ["slug"], name: "index_topics_on_slug", unique: true, using: :btree

  create_table "trails", force: :cascade do |t|
    t.string   "name",          limit: 255,                 null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "complete_text", limit: 255,                 null: false
    t.boolean  "published",                 default: false, null: false
    t.string   "slug",          limit: 255,                 null: false
    t.text     "description",               default: "",    null: false
    t.integer  "topic_id",                                  null: false
  end

  add_index "trails", ["published"], name: "index_trails_on_published", using: :btree
  add_index "trails", ["slug"], name: "index_trails_on_slug", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",              limit: 255
    t.string   "encrypted_password", limit: 128
    t.string   "salt",               limit: 128
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128
    t.boolean  "email_confirmed",                default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference",          limit: 255
    t.boolean  "admin",                          default: false, null: false
    t.string   "stripe_customer_id", limit: 255, default: "",    null: false
    t.string   "github_username",                                null: false
    t.string   "auth_provider",      limit: 255
    t.integer  "auth_uid"
    t.string   "organization",       limit: 255
    t.string   "address1",           limit: 255
    t.string   "address2",           limit: 255
    t.string   "city",               limit: 255
    t.string   "state",              limit: 255
    t.string   "zip_code",           limit: 255
    t.string   "country",            limit: 255
    t.string   "name",               limit: 255
    t.text     "bio"
    t.integer  "team_id"
    t.string   "utm_source"
    t.boolean  "completed_welcome",              default: false, null: false
  end

  add_index "users", ["admin"], name: "index_users_on_admin", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["github_username"], name: "index_users_on_github_username", unique: true, using: :btree
  add_index "users", ["id", "confirmation_token"], name: "index_users_on_id_and_confirmation_token", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

  create_table "vanity_conversions", force: :cascade do |t|
    t.integer "vanity_experiment_id"
    t.integer "alternative"
    t.integer "conversions"
  end

  add_index "vanity_conversions", ["vanity_experiment_id", "alternative"], name: "by_experiment_id_and_alternative", using: :btree

  create_table "vanity_experiments", force: :cascade do |t|
    t.string   "experiment_id"
    t.integer  "outcome"
    t.datetime "created_at"
    t.datetime "completed_at"
  end

  add_index "vanity_experiments", ["experiment_id"], name: "index_vanity_experiments_on_experiment_id", using: :btree

  create_table "vanity_metric_values", force: :cascade do |t|
    t.integer "vanity_metric_id"
    t.integer "index"
    t.integer "value"
    t.string  "date"
  end

  add_index "vanity_metric_values", ["vanity_metric_id"], name: "index_vanity_metric_values_on_vanity_metric_id", using: :btree

  create_table "vanity_metrics", force: :cascade do |t|
    t.string   "metric_id"
    t.datetime "updated_at"
  end

  add_index "vanity_metrics", ["metric_id"], name: "index_vanity_metrics_on_metric_id", using: :btree

  create_table "vanity_participants", force: :cascade do |t|
    t.string   "experiment_id"
    t.string   "identity"
    t.integer  "shown"
    t.integer  "seen"
    t.integer  "converted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vanity_participants", ["experiment_id", "converted"], name: "by_experiment_id_and_converted", using: :btree
  add_index "vanity_participants", ["experiment_id", "identity"], name: "by_experiment_id_and_identity", using: :btree
  add_index "vanity_participants", ["experiment_id", "seen"], name: "by_experiment_id_and_seen", using: :btree
  add_index "vanity_participants", ["experiment_id", "shown"], name: "by_experiment_id_and_shown", using: :btree
  add_index "vanity_participants", ["experiment_id"], name: "index_vanity_participants_on_experiment_id", using: :btree

  create_table "videos", force: :cascade do |t|
    t.integer  "watchable_id"
    t.string   "wistia_id",         limit: 255
    t.string   "name",              limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "watchable_type",    limit: 255
    t.integer  "position",                      default: 0, null: false
    t.text     "notes"
    t.date     "published_on"
    t.string   "preview_wistia_id", limit: 255
    t.string   "slug",              limit: 255,             null: false
    t.text     "summary"
    t.integer  "length_in_minutes"
  end

  add_index "videos", ["slug"], name: "index_videos_on_slug", unique: true, using: :btree
  add_index "videos", ["watchable_type", "watchable_id"], name: "index_videos_on_watchable_type_and_watchable_id", using: :btree

  add_foreign_key "attempts", "flashcards", on_delete: :cascade
  add_foreign_key "attempts", "users", on_delete: :cascade
  add_foreign_key "markers", "videos", on_delete: :cascade
      create_view :latest_attempts, sql_definition:<<-SQL
        SELECT DISTINCT ON (attempts.user_id, attempts.flashcard_id) attempts.id,
  attempts.confidence,
  attempts.flashcard_id,
  attempts.user_id,
  attempts.created_at,
  attempts.updated_at
 FROM attempts
ORDER BY attempts.user_id, attempts.flashcard_id, attempts.updated_at DESC;
      SQL

        create_view :licenses, sql_definition:<<-SQL
          SELECT subscriptions.id AS subscription_id,
    subscriptions.user_id,
    subscriptions.user_id AS owner_id,
    subscriptions.plan_type,
    subscriptions.plan_id,
    users.completed_welcome
   FROM (subscriptions
     JOIN users ON ((users.id = subscriptions.user_id)))
  WHERE (subscriptions.deactivated_on IS NULL)
UNION ALL
 SELECT subscriptions.id AS subscription_id,
    users.id AS user_id,
    subscriptions.user_id AS owner_id,
    subscriptions.plan_type,
    subscriptions.plan_id,
    users.completed_welcome
   FROM ((teams
     JOIN users ON ((users.team_id = teams.id)))
     JOIN subscriptions ON ((subscriptions.id = teams.subscription_id)))
  WHERE (subscriptions.deactivated_on IS NULL);
        SQL

        create_view :slugs, sql_definition:<<-SQL
          SELECT products.slug,
    products.type AS model
   FROM products
UNION ALL
 SELECT trails.slug,
    'Trail'::character varying AS model
   FROM trails;
        SQL

end
