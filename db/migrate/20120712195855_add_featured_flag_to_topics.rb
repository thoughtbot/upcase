class AddFeaturedFlagToTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :topics, :featured, :boolean, default: false, null: false
  end
end
