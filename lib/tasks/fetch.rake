namespace :fetch do
  namespace :tumblr do
    desc "Fetch posts from thoughtbot tumblr blog"
    task :recent => :environment do
      posts = Tumblr.recent
      Loader.import_articles_and_topics(posts)
    end

    task :all => :environment do
      posts = Tumblr.all
      Loader.import_articles_and_topics(posts)
    end
  end

  desc "Fetch trail maps from github and update topics"
  task :trails => :environment do
    Topic.import_top_trail_maps
  end
end

