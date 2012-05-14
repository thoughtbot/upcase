namespace :dev do
  desc "Creates some sample data for testing locally"
  task :prime => 'db:migrate' do
    require 'database_cleaner'
    require 'factory_girl_rails'

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    puts "Creating development data..."

    create_list(3, :section)

    admin = create(:admin, email: 'admin@example.com')
    puts "admin login: #{admin.email} / #{admin.password}"

    puts "done."
  end
end
