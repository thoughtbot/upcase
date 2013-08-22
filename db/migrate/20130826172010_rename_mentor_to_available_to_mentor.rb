class RenameMentorToAvailableToMentor < ActiveRecord::Migration
  def change
    rename_column :users, :mentor, :available_to_mentor
  end
end
