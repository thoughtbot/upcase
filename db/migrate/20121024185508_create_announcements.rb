class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.timestamps null: false
      t.references :announceable, polymorphic: true, null: false
      t.text :message, null: false
      t.datetime :ends_at, null: false
    end

    add_index :announcements, [:announceable_id, :announceable_type, :ends_at],
      name: :index_announcements_on_announceable_and_ends_at
  end
end
