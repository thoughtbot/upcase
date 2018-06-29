class RemoveTopicColors < ActiveRecord::Migration[4.2]
  def change
    remove_column :topics, :color
    remove_column :topics, :color_accent
  end
end
