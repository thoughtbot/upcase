class CreateQuizQuestions < ActiveRecord::Migration[4.2]
  def change
    create_table :questions do |t|
      t.text :prompt, null: false
      t.text :answer, null: false
      t.integer :position, null: false
      t.references :quiz, null: false

      t.timestamps null: false
    end

    add_index :questions, :quiz_id
  end
end
