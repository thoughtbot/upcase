class AddFeaturedFlagToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :featured, :boolean, default: false, null: false
  end
end
