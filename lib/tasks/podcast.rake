namespace :podcast do
  namespace :publish do
    desc 'Publish any podcast episodes to tumblr'
    task :tumblr do
      Episode.promote_published_today
    end
  end
end
