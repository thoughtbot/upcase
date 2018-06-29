class AddTitleToQuestion < ActiveRecord::Migration[4.2]
  def up
    add_column :questions, :title, :string
    backfill_existing_question_titles
    change_column_null :questions, :title, false
  end

  def down
    remove_column :questions, :title
  end

  def backfill_existing_question_titles
    execute <<-SQL
      update questions set title = '';
    SQL
  end
end
