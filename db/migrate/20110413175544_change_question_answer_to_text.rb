class ChangeQuestionAnswerToText < ActiveRecord::Migration
  def self.up
    change_column :questions, :answer, :text
  end

  def self.down
    change_column :questions, :answer, :string
  end
end
