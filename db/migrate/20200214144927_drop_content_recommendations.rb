class DropContentRecommendations < ActiveRecord::Migration[5.2]
  def change
    drop_table "content_recommendations" do |t|
      t.integer "user_id", null: false
      t.string "recommendable_type", null: false
      t.integer "recommendable_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id", "recommendable_type", "recommendable_id"], name: "index_content_recommendations_on_recommendable_and_user", unique: true
      t.index ["user_id"], name: "index_content_recommendations_on_user_id"
    end
  end
end
