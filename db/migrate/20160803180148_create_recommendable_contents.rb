class CreateRecommendableContents < ActiveRecord::Migration[4.2]
  def change
    create_table :recommendable_contents do |t|
      t.integer :recommendable_id, null: false
      t.string :recommendable_type, null: false
      t.integer :position, null: false

      t.timestamps null: false
    end

    add_index(
      :recommendable_contents,
      [:recommendable_type, :recommendable_id],
      name: "rec_contents_on_rec_type_rec_id"
    )
  end
end
