class AddCountToTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :topics, :count, :integer
  end
end
