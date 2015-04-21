namespace :dev do
  desc 'Creates sample data for local development'
  task prime: ['db:setup'] do
    unless Rails.env.development?
      raise 'This task can only be run in the development environment'
    end

    require 'factory_girl_rails'
    include FactoryGirl::Syntax::Methods

    create_individual_plans
    create_topics
    create_products
    create_episodes
    create_mentors
    create_users
    create_team_plan
    create_trails
  end

  def create_individual_plans
    @basic_plan = create(
      :plan,
      :featured,
      price_in_dollars: 9,
      name: "The Weekly Iteration",
      short_description: "One new video per week on advanced Ruby topics.",
      sku: "the-weekly-iteration",
    )

    @discounted_annual_plan = create(
      :discounted_annual_plan,
      price_in_dollars: 199,
      name: "Discounted Annual Plan",
      short_description: "Everything you're used to, but a bit cheaper",
      sku: Plan::DISCOUNTED_ANNUAL_PLAN_SKU,
    )

    @professional_plan = create(
      :plan,
      :featured,
      price_in_dollars: 29,
      name: "Professional",
      short_description: "Do exercises and become a general whiz kid.",
      sku: "professional",
    )

    @mentor_plan = create(
      :plan,
      :featured,
      includes_mentor: true,
      price_in_dollars: 249,
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
    FactoryGirl.create(
      :repository,
      name: "Testing Fundamentals First Repo",
      trail: trail
    )
    FactoryGirl.create(
      :repository,
      name: "Testing Fundamentals Second Repo",
      trail: trail
    )
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
      wistia_id: "uaxw299qz9",
      preview_wistia_id: "uaxw299qz9"
    )
    teach video, bio: "The Amazing Dan"
    FactoryGirl.create(:step, trail: trail, completeable: video)

    puts_trail trail, "unstarted"

    trail = FactoryGirl.create(:trail, :published, name: "Design Essentials")
    trail.update(topic: Topic.find_by(slug: "design"))
    video = create(
      :video,
      notes: "Blah" + " blah" * 100,
      published_on: 1.day.ago,
      name: "Squares",
    )
    teach video, bio: "I am Dan"
    FactoryGirl.create(:step, trail: trail, completeable: video)
    video = create(
      :video,
      notes: "Blah" + " blah" * 100,
      published_on: 1.day.ago,
      name: "Circles",
    )
    teach video, bio: "Dan I am"
    FactoryGirl.create(:step, trail: trail, completeable: video)

    puts_trail trail, "unstarted"

    trail = FactoryGirl.create(:trail, :published, name: "Refactoring")
    trail.update(topic: Topic.find_by(slug: "clean-code"))
    create_steps_for(
      trail,
      "Extract Method",
      "Extract Class",
      "Replace Variable with Query"
    )
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
      exercise = FactoryGirl.create(:exercise, name: name)
      FactoryGirl.create(:step, trail: trail, completeable: exercise)
    end
  end

  def teach(video, bio:)
    user = FactoryGirl.create(:user, bio: bio)
    FactoryGirl.create(:teacher, video: video, user: user)
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

  def puts_user(user, description)
    puts "#{user.email} / #{user.password} (#{description})"
  end

  def puts_trail(trail, description)
    puts "#{trail.name} (#{description})"
  end
end
