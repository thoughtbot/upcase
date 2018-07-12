class CreateFollowUps < ActiveRecord::Migration[4.2]
  def self.up
    create_table :follow_ups do |t|
      t.string :email
      t.references :course

      t.timestamps
    end

    add_index :follow_ups, :course_id
  end

  def self.down
    drop_table :follow_ups
  end
end
