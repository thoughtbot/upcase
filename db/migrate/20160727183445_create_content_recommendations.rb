class CreateContentRecommendations < ActiveRecord::Migration[4.2]
  def change
    create_table :content_recommendations do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :recommendable, polymorphic: true, null: false

      t.timestamps null: false
    end

    add_index(
      :content_recommendations,
      [:user_id, :recommendable_type, :recommendable_id],
      name: "index_content_recommendations_on_recommendable_and_user",
      unique: true,
    )
  end
end
