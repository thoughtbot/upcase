namespace :wistia do
  task update_video_durations: :environment do
    VideoDurationUpdater.update_all_durations
  end
end
