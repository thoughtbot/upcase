class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.timestamps null: false
      t.references :announceable, polymorphic: true, null: false
      t.text :message, null: false
      t.datetime :ends_at, null: false
    end

    add_index :announcements, :announceable_id
  end
end
