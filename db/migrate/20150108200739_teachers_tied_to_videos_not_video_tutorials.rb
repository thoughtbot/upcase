class TeachersTiedToVideosNotVideoTutorials < ActiveRecord::Migration[4.2]
  # Thom informs: joe has been on every episode of WI except #3
  # (improving-your-workflow-with-chris-toomey) and #35 (landing-a-rails-job)
  # Ben has been present until episode 47, Rubyisms in Swift
  BEN_USER_ID = 95
  RUBYISMS_IN_SWIFT_ID = 179

  JOE_USER_ID = 524
  IMPROVING_YOUR_WORKFLOW_ID = 86
  LANDING_A_RAILS_JOB_ID = 167

  def change
    convert_teachers_video_tutorial_ids_video_ids

    add_ben_to_his_twi_videos
    add_joe_to_his_twi_videos

    rename_column :teachers, :video_tutorial_id, :video_id
  end

  private

  def add_ben_to_his_twi_videos
    connection.insert(<<-SQL)
      INSERT INTO teachers (user_id, video_tutorial_id)
        (SELECT #{BEN_USER_ID}, videos.id FROM videos
          WHERE watchable_id = 23 AND id < #{RUBYISMS_IN_SWIFT_ID})
    SQL
  end

  def add_joe_to_his_twi_videos
    connection.insert(<<-SQL)
      INSERT INTO teachers (user_id, video_tutorial_id)
        (SELECT #{JOE_USER_ID}, videos.id FROM videos
          WHERE watchable_id = 23
            AND id != #{IMPROVING_YOUR_WORKFLOW_ID}
            AND id != #{LANDING_A_RAILS_JOB_ID })
    SQL
  end

  def convert_teachers_video_tutorial_ids_video_ids
    connection.insert(<<-SQL)
      WITH user_id_video_id AS (
        SELECT
          teachers.user_id AS user_id,
          videos.watchable_id AS video_tutorial_id,
          videos.id AS video_id
        FROM teachers
          LEFT JOIN products ON teachers.video_tutorial_id = products.id
          LEFT JOIN videos ON products.id = videos.watchable_id
      )
      -- This is not cleaning up old video_tutorial_id references
      INSERT INTO teachers (user_id, video_tutorial_id)
        (SELECT user_id, video_id FROM user_id_video_id)
    SQL
  end
end
