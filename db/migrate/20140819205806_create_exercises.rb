class CreateExercises < ActiveRecord::Migration[4.2]
  def change
    create_table :exercises do |table|
      table.string :title, null: false
      table.string :url, null: false
      table.text :summary, null: false

      table.timestamps
    end
  end
end
