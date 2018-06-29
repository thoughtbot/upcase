class RemoveLegacyTrailsAndCompletions < ActiveRecord::Migration[4.2]
  def up
    drop_table :legacy_trails
    drop_table :completions
  end

  def down
    create_legacy_trails_table
    create_completions_table
  end

  private

  def create_legacy_trails_table
    create_table "legacy_trails" do |t|
      t.integer "topic_id"
      t.string "slug"
      t.text "trail_map"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index(
      "legacy_trails",
      ["topic_id"],
      name: "index_legacy_trails_on_topic_id"
    )
  end

  def create_completions_table
    create_table "completions" do |t|
      t.string "trail_object_id"
      t.string "trail_name"
      t.integer "user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "slug"
    end

    add_index(
      "completions",
      ["trail_object_id"],
      name: "index_completions_on_trail_object_id"
    )
    add_index(
      "completions",
      ["user_id"],
      name: "index_completions_on_user_id"
    )
  end
end
