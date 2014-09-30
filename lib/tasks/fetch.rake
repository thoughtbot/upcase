namespace :fetch do
  desc "Fetch trail maps from github and update topics"
  task :trails => :environment do
    LegacyTrail.import
  end
end

