class DropTableAnnouncements < ActiveRecord::Migration[4.2]
  def change
    drop_table :announcements
  end
end
