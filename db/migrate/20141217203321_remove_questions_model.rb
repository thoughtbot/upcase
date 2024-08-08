class RemoveQuestionsModel < ActiveRecord::Migration[4.2]
  def up
    questions = select_all(
      "SELECT * FROM questions WHERE video_tutorial_id IS NOT NULL"
    )
    questions.each do |question|
      update <<-SQL
        UPDATE products
        SET questions = questions ||
          #{quote("\n### #{question["question"]}\n\n#{question["answer"]}\n")}
        WHERE id=#{question["video_tutorial_id"]} AND
        type='VideoTutorial'
      SQL
    end

    drop_table :questions
  end

  def down
    create_table :questions do |table|
      table.integer :video_tutorial_id
      table.string :question
      table.text :answer
      table.timestamps
      table.index :video_tutorial_id
    end
  end
end
