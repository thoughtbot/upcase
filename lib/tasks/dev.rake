namespace :dev do
  desc 'Creates sample data for local development'
  task prime: ['db:reset'] do
    unless Rails.env.development?
      raise 'This task can only be run in the development environment'
    end

    require 'factory_girl_rails'

    create_sections
    create_users
  end

  def create_sections
    FactoryGirl.create_list :section, 3
  end

  def create_users
    puts "\n\n*** USERS ***\n\n"

    user = FactoryGirl.create(:admin, email: 'admin@example.com')
    puts_user user, 'admin'

    user = FactoryGirl.create(:user, email: 'none@example.com')
    puts_user user, 'no purchases'

    user = FactoryGirl.create(:user, email: 'product@example.com')
    FactoryGirl.create :purchase, :free, user: user
    puts_user user, 'product purchase'

    user = FactoryGirl.create(:user, email: 'workshop@example.com')
    FactoryGirl.create :section_purchase, :free, user: user
    puts_user user, 'workshop purchase'

    user = FactoryGirl.create(:user, email: 'both@example.com')
    FactoryGirl.create :purchase, :free, user: user
    FactoryGirl.create :section_purchase, :free, user: user
    puts_user user, 'product and workshop purchase'

    puts "\n"
  end

  def puts_user(user, description)
    puts "#{user.email} / #{user.password} (#{description})"
  end
end
