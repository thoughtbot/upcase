class DropRecommendableContents < ActiveRecord::Migration[5.2]
  def change
    drop_table "recommendable_contents" do |t|
      t.integer "recommendable_id", null: false
      t.string "recommendable_type", null: false
      t.integer "position", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["recommendable_type", "recommendable_id"], name: "rec_contents_on_rec_type_rec_id"
    end
  end
end
