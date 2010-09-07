class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.belongs_to :user, :section
      t.timestamps
    end
    add_index :registrations, :user_id
    add_index :registrations, :section_id
  end

  def self.down
    drop_table :registrations
  end
end
