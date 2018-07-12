class AddCompletedWelcomeToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :completed_welcome, :boolean, default: false

    connection.update(<<-SQL)
      UPDATE users SET completed_welcome = 't'
    SQL

    change_column_null :users, :completed_welcome, false
  end
end
