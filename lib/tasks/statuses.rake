namespace :statuses do
  desc "Rename old states in state column"
  task update_states: :environment do
    Status.where(state: "Reviewed").update_all(state: "Complete")
    Status.where("state != ?", "Complete").update_all(state: "In Progress")
  end
end
