class RenameWorkshopsToVideoTutorials < ActiveRecord::Migration[4.2]
  def change
    rename_column :individual_plans, :includes_workshops, :includes_video_tutorials
    rename_column :team_plans, :includes_workshops, :includes_video_tutorials

    rename_column :questions, :workshop_id, :video_tutorial_id
    rename_column :teachers, :workshop_id, :video_tutorial_id

    rename_table :workshops, :video_tutorials
  end
end
