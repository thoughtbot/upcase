class RemoveArticlesTopicsJoinTable < ActiveRecord::Migration
  def up
    drop_table :articles_topics
  end

  def down
    create_table :articles_topics, id: false do |t|
      t.integer :article_id, null: false
      t.integer :topic_id,   null: false
    end

    add_index :articles_topics, [:article_id, :topic_id], unique: true
  end
end
