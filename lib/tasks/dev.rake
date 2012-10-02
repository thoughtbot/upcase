namespace :dev do
  desc "Creates some sample data for testing locally"
  task prime: 'db:migrate' do
    require 'database_cleaner'
    require 'factory_girl_rails'

    if Rails.env != "development"
      raise "This task can only be create in the development environment"
    end

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    puts "Creating development data..."

    FactoryGirl.create_list(:section, 3)

    puts ""
    puts "**** USERS ****"

    admin = FactoryGirl.create(:admin, email: 'admin@example.com')
    puts "Admin login: #{admin.email} / #{admin.password}"

    user_with_workshop = FactoryGirl.create(:user, email: "workshop@example.com")
    FactoryGirl.build(:paid_registration, user: user_with_workshop)
    puts "User: #{user_with_workshop.email} / #{user_with_workshop.password} - has a workshop"

    user_with_product = FactoryGirl.create(:user, email: "product@example.com")
    FactoryGirl.create(:free_purchase, user: user_with_product)
    puts "User: #{user_with_product.email} / #{user_with_product.password} - has a product"

    user_with_workshop_and_product = FactoryGirl.create(:user, email: "both@example.com")
    FactoryGirl.create(:paid_registration, user: user_with_workshop_and_product)
    FactoryGirl.create(:free_purchase, user: user_with_workshop_and_product)
    puts "User: #{user_with_workshop_and_product.email} / #{user_with_workshop_and_product.password} - has a product and a workshop"

    basic_user = FactoryGirl.create(:user, email: "noproduct@example.com")
    puts "Users: #{basic_user.email} / #{basic_user.password}  - has no products or workshops"
    puts "**** DONE ****"
    puts ""
  end
end
