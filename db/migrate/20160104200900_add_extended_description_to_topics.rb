class AddExtendedDescriptionToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :extended_description, :text
  end
end
