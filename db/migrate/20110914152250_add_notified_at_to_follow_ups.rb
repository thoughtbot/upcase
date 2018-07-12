class AddNotifiedAtToFollowUps < ActiveRecord::Migration[4.2]
  def self.up
    add_column :follow_ups, :notified_at, :datetime
  end

  def self.down
    remove_column :follow_ups, :notified_at
  end
end
