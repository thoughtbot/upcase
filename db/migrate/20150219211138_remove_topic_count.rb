class RemoveTopicCount < ActiveRecord::Migration[4.2]
  def up
    remove_column :topics, :count
  end

  def down
    add_column :topics, :count, :integer
  end
end
