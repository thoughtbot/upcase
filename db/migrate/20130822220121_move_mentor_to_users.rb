class MoveMentorToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :mentor_id, :integer
    execute <<-SQL
      UPDATE users u
      SET mentor_id = s.mentor_id
      FROM subscriptions s
      WHERE u.id = s.user_id
    SQL
    add_index :users, :mentor_id

    remove_column :subscriptions, :mentor_id
  end

  def down
    add_column :subscriptions, :mentor_id, :integer
    execute <<-SQL
      UPDATE subscriptions s
      SET mentor_id = u.mentor_id
      FROM users u
      WHERE s.user_id = u.id
    SQL
    change_column_null :subscriptions, :mentor_id, false
    add_index :subscriptions, :mentor_id

    remove_column :users, :mentor_id
  end
end
