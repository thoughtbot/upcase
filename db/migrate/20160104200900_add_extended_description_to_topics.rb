class AddExtendedDescriptionToTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :topics, :extended_description, :text
  end
end
