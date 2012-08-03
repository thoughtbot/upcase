namespace :playbook do
  desc 'Import all pages in the thoughtbot playbook'
  task import: :environment do
    Playbook::Scraper.new('http://playbook.thoughtbot.com', '').scrape
  end
end
