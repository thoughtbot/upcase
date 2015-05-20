class AddPublishedFlagToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :published, :boolean, null: false, default: false
  end
end
