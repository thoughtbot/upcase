class RemoveTopicCount < ActiveRecord::Migration
  def up
    remove_column :topics, :count
  end

  def down
    add_column :topics, :count, :integer
  end
end
