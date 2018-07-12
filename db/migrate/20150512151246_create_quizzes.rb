class CreateQuizzes < ActiveRecord::Migration[4.2]
  def change
    create_table :quizzes do |t|
      t.string :title, null: false

      t.timestamps null: false
    end
  end
end
