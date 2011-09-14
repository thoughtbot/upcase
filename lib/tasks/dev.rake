namespace :dev do
  desc "Creates some sample data for testing locally"
  task :prime => 'db:migrate' do
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    Dir[Rails.root.join("vendor", "gems", "factory_girl-*", "lib")].each do |path|
      $LOAD_PATH << path
    end
    require 'factory_girl'
    FactoryGirl.find_definitions

    puts "Creating development data..."

    Factory(:section)
    Factory(:section)
    Factory(:section)

    admin = Factory(:admin, :email => 'admin@example.com')
    puts "admin login: #{admin.email} / #{admin.password}"

    puts "done."
  end
end
