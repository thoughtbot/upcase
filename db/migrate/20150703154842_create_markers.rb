class CreateMarkers < ActiveRecord::Migration[4.2]
  def change
    create_table :markers do |t|
      t.string :anchor, null: false
      t.integer :time, null: false
      t.references :video, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :markers, :videos, on_delete: :cascade
  end
end
