class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.text :description, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
