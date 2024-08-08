class CreateArticlesTopicsJoinTable < ActiveRecord::Migration[4.2]
  def change
    create_table :articles_topics, id: false do |t|
      t.integer :article_id, null: false
      t.integer :topic_id, null: false
    end

    add_index :articles_topics, [:article_id, :topic_id], unique: true
  end
end
