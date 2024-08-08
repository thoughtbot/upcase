class RemoveBytes < ActiveRecord::Migration[4.2]
  def up
    drop_table :bytes
  end

  def down
    create_table "bytes", force: true do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "title", null: false
      t.text "body_html", null: false
      t.date "published_on", null: false
      t.text "body", null: false
      t.boolean "draft", default: false, null: false
    end

    add_index "bytes", ["draft"], name: "index_bytes_on_draft", using: :btree
    add_index "bytes", ["published_on"], name: "index_bytes_on_published_on", using: :btree
  end
end
