class RemoveFeaturedFromTopics < ActiveRecord::Migration[4.2]
  def up
    remove_column :topics, :featured
  end

  def down
    add_column :topics, :featured, :boolean, default: false, null: false
  end
end
