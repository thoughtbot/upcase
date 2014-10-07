namespace :dev do
  desc 'Creates sample data for local development'
  task upcase: ['db:setup'] do
    unless Rails.env.development?
      raise 'This task can only be run in the development environment'
    end

    require 'factory_girl_rails'
    include FactoryGirl::Syntax::Methods

    create_individual_plans
    create_products
    create_video_tutorials
    create_mentors
    create_users
    create_team_plan
    create_topic
  end

  def create_individual_plans
    @basic_plan = create(:plan, {
      individual_price: 9,
      name: "The Weekly Iteration",
      short_description: "One new video per week on advanced Ruby topics.",
      sku: "the-weekly-iteration",
    })

    mentor_features = {
      includes_mentor: true,
      name: "1-on-1 Coaching",
      short_description: "Best for an active learner seeking 1-on-1 personal coaching.",
    }

    @mentor_plan = create(:plan, {
      sku: "prime-249",
      individual_price: 249,
    }.merge(mentor_features))
  end

  def create_products
    header "Products"

    puts_product FactoryGirl.create(:show, name: 'The Weekly Iteration')
  end

  def create_video_tutorials
    header "VideoTutorials"

    @video_tutorial = FactoryGirl.create(:video_tutorial,
      name: 'Intermediate Ruby on Rails',
      short_description: 'Dig deeper into Ruby on Rails.',
      description: 'This intermediate Ruby on Rails video_tutorial is designed for developers who have built a few smaller Rails applications and would like to start making more complicated ones...'
    )
    puts_video_tutorial @video_tutorial
  end

  def create_users
    header "Users"

    user = FactoryGirl.create(:admin, email: 'admin@example.com')
    puts_user user, 'admin'

    user = FactoryGirl.create(
      :admin,
      :with_subscription,
      :with_github,
      email: 'whetstone@example.com',
      plan: @mentor_plan,
    )
    puts_user user, 'ready to auth against whetstone'

    user = FactoryGirl.create(:user, email: 'none@example.com')
    puts_user user, 'no purchases'

    user = FactoryGirl.create(
      :basic_subscriber,
      email: 'basic@example.com',
      plan: @basic_plan,
    )
    puts_user user, 'basic subscriber'

    user = FactoryGirl.create(
      :subscriber,
      :includes_mentor,
      email: 'has_mentor@example.com',
      plan: @mentor_plan,
    )
    puts_user user, 'mentor subscriber'

    puts "\n"
  end

  def create_mentors
    header "Mentors"

    mentor = FactoryGirl.create(:user, email: 'mentor@example.com', admin: true)
    FactoryGirl.create(:mentor, user: mentor)
    puts_user mentor, 'mentor'

    puts "\n"
  end

  def create_team_plan
    FactoryGirl.create(:plan, :team)
  end

  def create_topic
    FactoryGirl.create(:topic, name: 'Ruby on Rails')
  end

  def header(msg)
    puts "\n\n*** #{msg.upcase} *** \n\n"
  end

  def puts_product(product)
    puts "#{product.name}"
  end

  def puts_video_tutorial(video_tutorial)
    puts "#{video_tutorial.name}"
  end

  def puts_video_tutorial(video_tutorial)
    puts "#{video_tutorial.name} (#{video_tutorial.starts_on} - #{video_tutorial.ends_on})"
  end

  def puts_user(user, description)
    puts "#{user.email} / #{user.password} (#{description})"
  end
end
