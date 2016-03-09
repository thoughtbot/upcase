class RemoveKeywordsFromTopics < ActiveRecord::Migration
  def change
    remove_column :topics, :keywords, :string
  end
end
