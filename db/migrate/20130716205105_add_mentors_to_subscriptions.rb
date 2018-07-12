class AddMentorsToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :mentor, :boolean, default: false
    update "update users set mentor=true where email = 'ben@thoughtbot.com'"
    update "update users set mentor=true where email = 'chad@thoughtbot.com'"

    add_column :subscriptions, :mentor_id, :integer
    add_index :subscriptions, :mentor_id

    update "update subscriptions set mentor_id = (SELECT id FROM users WHERE mentor=true LIMIT 1)"

    change_column_null :subscriptions, :mentor_id, false
  end
end
