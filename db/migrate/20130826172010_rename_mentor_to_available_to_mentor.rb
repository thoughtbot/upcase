class RenameMentorToAvailableToMentor < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :mentor, :available_to_mentor
  end
end
