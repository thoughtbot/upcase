namespace :dev do
  desc 'Creates sample data for local development'
  task upcase: ['db:setup'] do
    unless Rails.env.development?
      raise 'This task can only be run in the development environment'
    end

    require 'factory_girl_rails'
    include FactoryGirl::Syntax::Methods

    create_individual_plans
    create_topics
    create_products
    create_episodes
    create_video_tutorials
    create_mentors
    create_users
    create_team_plan
    create_trails
  end

  def create_individual_plans
    @basic_plan = create(
      :plan,
      price: 9,
      name: "The Weekly Iteration",
      short_description: "One new video per week on advanced Ruby topics.",
      sku: "the-weekly-iteration",
    )

    @professional_plan = create(
      :plan,
      price: 29,
      name: "Professional",
      short_description: "Do exercises and become a general whiz kid.",
      sku: "professional",
    )

    @mentor_plan = create(
      :plan,
      includes_mentor: true,
      price: 249,
      name: "1-on-1 Coaching",
      short_description: "Best for an active learner seeking 1-on-1 personal coaching.",
      sku: "prime-249",
    )
  end

  def create_products
    header "Products"

    @weekly_iteration = FactoryGirl.create(:show, name: "The Weekly Iteration")

    puts_product @weekly_iteration

    repository = FactoryGirl.create(
      :repository,
      name: "Upcase",
      tagline: <<-TAGLINE.strip_heredoc,
        Source for the main Upcase repository, including users, billing, video
        tutorials, and more.
      TAGLINE
      alternative_description: <<-ALTERNATIVE_DESCRIPTION.strip_heredoc,
        <li>
          <a href="https://codeclimate.com/repos/509bdbd313d6373b2b001546/feed">
            <img src="https://codeclimate.com/repos/509bdbd313d6373b2b001546/badges/ca2720aded19a6da11e7/gpa.svg" />
          </a>
        </li>
        <li>
          <a href="https://codeclimate.com/repos/509bdbd313d6373b2b001546/feed">
            <img src="https://codeclimate.com/repos/509bdbd313d6373b2b001546/badges/ca2720aded19a6da11e7/coverage.svg" />
          </a>
        </li>
      ALTERNATIVE_DESCRIPTION
      description: <<-DESCRIPTION.strip_heredoc
        This is the full source code the Rails app that runs the Upcase
        website. It includes authentication, users, subscription billing with
        Stripe, video tutorials, and more.

        As a subscriber, you have access to the source code of Upcase, this
        application. Clone it, disect it, and follow code reviews. See what a
        real-world, complex, fully tested production application looks like.

        We've been working full-time on Upcase for more than a year, and we
        think it's a good example of a large app with great code. Upcase has
        extensive test coverage, a full implementation of SaaS billing with
        Stripe, and serves as an OAuth endpoint for our Discourse forum, among
        other things. We encourage you to make changes and participate in pull
        request discussions. It has a 4.0 score on Code Climate.
      DESCRIPTION
    )
    puts_product repository
  end

  def create_episodes
    header "Episodes"

    create_episode 1, "Ping-pong TDD", "Testing"
    create_episode 2, "Unit vs Integration Testing", "Testing"
    create_episode 3, "Refactoring in steps", "Clean Code"
    create_episode 4, "Functional Swift", "iOS"
    create_episode 5, "Spring", "Ruby on Rails"
    create_episode 6, "Payload", "Ruby on Rails"
    create_episode 7, "Rails as a JSON database", "Ruby on Rails"
  end

  def create_episode(age_in_days, name, topic_name)
    episode = create(
      :video,
      notes: "Blah" + " blah" * 100,
      published_on: age_in_days.days.ago,
      name: name,
      watchable: @weekly_iteration
    )
    classify episode, topic_name
  end

  def create_video_tutorials
    header "VideoTutorials"
    user = FactoryGirl.create(:user, bio: "Dan is a seasoned Rails developer.")
    video = FactoryGirl.create(:video)
    FactoryGirl.create(:teacher, user: user, video: video)

    @video_tutorial = FactoryGirl.create(:video_tutorial,
      name: 'Intermediate Ruby on Rails',
      short_description: 'Dig deeper into Ruby on Rails.',
      tagline: 'Dig deeper into Ruby on Rails.',
      videos: [ video ],
      description: <<-DESCRIPTION.squish
        This intermediate Ruby on Rails video_tutorial is designed for
        developers who have built a few smaller Rails applications and would
        like to start making more complicated ones...
      DESCRIPTION
    )
    FactoryGirl.create(
      :repository,
      name: "Test-Driven Rails Part 1",
      product: @video_tutorial
    )
    FactoryGirl.create(
      :repository,
      name: "Test-Driven Rails Part 2",
      product: @video_tutorial
    )
    classify @video_tutorial, "Ruby on Rails"
    puts_video_tutorial @video_tutorial
  end

  def create_users
    header "Users"

    user = FactoryGirl.create(
      :admin,
      :with_subscription,
      :with_github,
      email: 'admin@example.com',
      plan: @mentor_plan
    )
    puts_user user, 'admin'

    user = FactoryGirl.create(
      :admin,
      :with_subscription,
      :with_github,
      email: 'whetstone@example.com',
      plan: @professional_plan,
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

  def create_topics
    create_topic color: "#E5FEFF", accent: "#1DC8CF", name: "Clean Code"
    create_topic color: "#E8E9FF", accent: "#2B2F8E", name: "Design"
    create_topic color: "#FFE8CA", accent: "#D87D2F", name: "Javascript"
    create_topic color: "#E1F5FF", accent: "#2192CF", name: "Vim"
    create_topic color: "#FCF5C8", accent: "#F4BC15", name: "Workflow"
    create_topic color: "#D7ECFF", accent: "#396189", name: "iOS"

    rails = FactoryGirl.create(:topic, :explorable, name: "Ruby on Rails")
    rails.update(slug: "rails")
    testing = FactoryGirl.create(:topic, :explorable, name: "Testing")
    testing.update(slug: "testing")
  end

  def create_topic(name:, color:, accent:)
    FactoryGirl.create(
      :topic,
      :explorable,
      name: name,
      color: color,
      color_accent: accent
    )
  end

  def create_trails
    header "Trails"
    user = User.find_by_email!("whetstone@example.com")

    trail = FactoryGirl.create(:trail, :published, name: "Testing Fundamentals")
    trail.update(topic: Topic.find_by(slug: "testing"))
    create_steps_for(
      trail,
      "Passing Your First Test",
      "Testing ActiveRecord",
      "Write an Integration Test"
    )
    video = create(
      :video,
      notes: "Blah" + " blah" * 100,
      published_on: 1.day.ago,
      name: "Red, Green, Refactor",
      watchable: @weekly_iteration,
      wistia_id: "uaxw299qz9",
      preview_wistia_id: "uaxw299qz9"
    )
    FactoryGirl.create(:step, trail: trail, completeable: video)

    classify_exercise "Passing Your First Test", "Testing"
    classify_exercise "Testing ActiveRecord", "Testing"
    classify_exercise "Write an Integration Test", "Testing"
    puts_trail trail, "unstarted"

    trail = FactoryGirl.create(:trail, :published, name: "Refactoring")
    trail.update(topic: Topic.find_by(slug: "clean-code"))
    create_steps_for(
      trail,
      "Extract Method",
      "Extract Class",
      "Replace Variable with Query"
    )
    classify_exercise "Extract Method", "Clean Code"
    classify_exercise "Extract Class", "Clean Code"
    classify_exercise "Replace Variable with Query", "Clean Code"
    FactoryGirl.create(:status,
      completeable: trail,
      state: Status::IN_PROGRESS,
      user: user
    )
    puts_trail trail, "in-progress"

    trail = FactoryGirl.create(:trail, :published, name: "iOS Development")
    steps = create_steps_for(
      trail,
      "Install Xcode",
      "Install Homebrew",
      "Intro to the App Store"
    )
    classify_exercise "Install Xcode", "iOS"
    classify_exercise "Install Homebrew", "Workflow"
    classify_exercise "Intro to the App Store", "iOS"
    FactoryGirl.create(:status,
      completeable: trail,
      state: Status::COMPLETE,
      user: user
    )

    steps.each do |step|
      FactoryGirl.create(
        :status,
        completeable: step.completeable,
        state: Status::COMPLETE,
        user: user
      )
    end

    puts_trail trail, "completed recently"

    trail = FactoryGirl.create(:trail, :published, name: "Android Development")
    steps = create_steps_for(
      trail,
      "Install Java",
      "Learn FRP",
      "Root your phone"
    )
    FactoryGirl.create(:status,
      completeable: trail,
      state: Status::COMPLETE,
      user: user,
      created_at: 30.days.ago
    )

    steps.each do |step|
      FactoryGirl.create(
        :status,
        completeable: step.completeable,
        state: Status::COMPLETE,
        user: user,
        created_at: 30.days.ago
      )
    end

    puts_trail trail, "completed more than 5 days ago"

    puts "(Please sign in as whetstone@example.com to see trail progress.)"
  end

  def create_steps_for(trail, *names)
    names.map do |name|
      exercise = FactoryGirl.create(:exercise, name: name, public: true)
      FactoryGirl.create(:step, trail: trail, completeable: exercise)
    end
  end

  def classify_exercise(name, topic_name)
    classify Exercise.find_by!(name: name), topic_name
  end

  def classify(classifiable, topic_name)
    topic = Topic.find_by!(name: topic_name)
    classifiable.classifications.create!(topic: topic)
  end

  def header(msg)
    puts "\n\n*** #{msg.upcase} *** \n\n"
  end

  def puts_product(product)
    puts product.name
  end

  def puts_video_tutorial(video_tutorial)
    puts video_tutorial.name
  end

  def puts_user(user, description)
    puts "#{user.email} / #{user.password} (#{description})"
  end

  def puts_trail(trail, description)
    puts "#{trail.name} (#{description})"
  end
end
