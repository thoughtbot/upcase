class AddNotifiedAtToFollowUps < ActiveRecord::Migration
  def self.up
    add_column :follow_ups, :notified_at, :datetime
  end

  def self.down
    remove_column :follow_ups, :notified_at
  end
end
