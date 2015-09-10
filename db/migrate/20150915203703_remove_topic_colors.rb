class RemoveTopicColors < ActiveRecord::Migration
  def change
    remove_column :topics, :color
    remove_column :topics, :color_accent
  end
end
