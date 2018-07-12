class AddPublishedFlagToQuizzes < ActiveRecord::Migration[4.2]
  def change
    add_column :quizzes, :published, :boolean, null: false, default: false
  end
end
