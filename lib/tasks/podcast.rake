require Rails.root.join('app/models/episode.rb')

namespace :podcast do
  namespace :publish do
    desc 'Publish any podcast episodes to tumblr'
    task tumblr: :environment do
      p 'running promote_published_today'
      p Episode.promote_published_today
    end
  end
end
