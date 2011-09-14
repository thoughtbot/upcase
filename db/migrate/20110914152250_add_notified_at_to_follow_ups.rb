class AddNotifiedAtToFollowUps < ActiveRecord::Migration
  def self.up
    add_column :follow_ups, :notified_at, :datetime
    connection.update_sql("UPDATE follow_ups SET notified_at='#{Time.now.utc}'")
  end

  def self.down
    remove_column :follow_ups, :notified_at
  end
end
