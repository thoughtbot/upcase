class RemoveArticles < ActiveRecord::Migration[4.2]
  def up
    drop_table :articles
  end

  def down
    create_table "articles", force: true do |t|
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
      t.string   "title",        null: false
      t.text     "body_html",    null: false
      t.string   "external_url", null: false
      t.date     "published_on", null: false
    end
  end
end
