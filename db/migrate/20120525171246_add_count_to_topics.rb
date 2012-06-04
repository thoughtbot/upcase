class AddCountToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :count, :integer

  end
end
