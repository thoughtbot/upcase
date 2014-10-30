namespace :statuses do
  desc "Create Trails statuses"
  task update_states: :environment do
    User.find_each do |user|
      Trail.find_each { |trail| trail.update_state_for(user) }
    end
  end
end
