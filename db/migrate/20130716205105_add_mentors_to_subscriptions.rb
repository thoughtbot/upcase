class AddMentorsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :mentor_id, :integer, null: false
    add_index :subscriptions, :mentor_id

    subscriptions = select_all('select id from subscriptions')
    subscriptions.each do |subscription|
      update "update subscriptions set mentor_id = #{mentor_id(subscription['id'])} where id=#{subscription['id']}"
    end
  end

  def mentor_id(subscription_id)
    ben_id = select_value("select id from users where email = 'ben@thoughtbot.com'")
    chad_id = select_value("select id from users where email = 'chad@thoughtbot.com'")
    if subscription_id.to_i.even?
      chad_id
    else
      ben_id
    end
  end
end
