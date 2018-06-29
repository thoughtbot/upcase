class RemoveKeywordsFromTopics < ActiveRecord::Migration[4.2]
  def change
    remove_column :topics, :keywords, :string
  end
end
