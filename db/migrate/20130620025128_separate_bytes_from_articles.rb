class SeparateBytesFromArticles < ActiveRecord::Migration[4.2]
  def up
    create_table "bytes", force: true do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "title", null: false
      t.text "body_html", null: false
      t.date "published_on", null: false
      t.text "body"
      t.boolean "draft", default: false, null: false
    end

    insert <<-SQL
      INSERT INTO bytes
      (id, created_at, updated_at, title, body_html, published_on, body, draft)
      (
        SELECT
          id, created_at, updated_at, title, body_html, published_on, body, draft
          FROM articles
          WHERE external_url IS NULL OR external_url = ''
      )
    SQL

    delete "DELETE FROM articles WHERE external_url IS NULL OR external_url = ''"

    update <<-SQL
      UPDATE classifications SET classifiable_type='Byte'
      FROM bytes
      WHERE classifiable_type='Article' AND classifiable_id=bytes.id
    SQL

    add_index :bytes, :published_on
    add_index :bytes, :draft

    remove_column :articles, :draft
    remove_column :articles, :body
  end

  def down
    add_column :articles, :draft, :boolean, default: false, null: false
    add_column :articles, :body, :text

    update <<-SQL
      UPDATE classifications SET classifiable_type='Article'
      FROM bytes
      WHERE classifiable_type='Byte' AND classifiable_id=bytes.id
    SQL

    insert <<-SQL
      INSERT INTO articles
        (id, created_at, updated_at, title, body_html, published_on, body, draft)
      (
        SELECT
          id, created_at, updated_at, title, body_html, published_on, body, draft
        FROM bytes
      )
    SQL

    drop_table :bytes
  end
end
