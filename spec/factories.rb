FactoryGirl.define do
  sequence :code do |n|
    "code#{n}"
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :name do |n|
    "name #{n}"
  end

  sequence :uuid do |n|
    "uuid_#{n}"
  end

  sequence :github_username do |n|
    "github_#{n}"
  end

  sequence :title do |n|
    "title #{n}"
  end

  sequence :external_url do |n|
    "http://robots.thoughtbot.com/#{n}"
  end

  factory :classification do
    association :classifiable, factory: :product
    topic
  end

  factory :coupon do
    amount 10
    code
    discount_type 'percentage'

    factory :one_time_coupon do
      one_time_use_only true
    end
  end

  factory :video_tutorial, parent: :product do
    name { generate(:name) }
    sku 'EIGHTQUEENS'

    factory :private_video_tutorial do
      active false
    end

    trait :github do
      github_team 9999
    end
  end

  factory :download do
    download_file_name { 'some_video.mpg' }
  end

  factory :note do
    body 'Default note body'
    user
    contributor { user }

    trait :current_week do
      created_at Time.zone.local(2013, 'aug', 5)
    end
  end

  factory :product, traits: [:active], class: "VideoTutorial" do
    after(:stub) { |product| product.slug = product.name.parameterize }
    description 'Solve 8-Queens over and over again'
    tagline 'Solve 8-Queens'

    trait :active do
      active true
    end

    trait :inactive do
      active false
    end

    trait :promoted do
      promoted true
    end

    company_price 50
    individual_price 15
    name { generate(:name) }
    sku 'TEST'

    factory :show, class: 'Show' do
    end

    factory :repository, class: 'Repository' do
      github_team 9999
      github_url "https://github.com/thoughtbot/upcase"
    end
  end

  factory :plan do
    name I18n.t("shared.subscription.name")
    individual_price 99
    sku "professional"
    short_description 'A great Subscription'
    description 'A long description'

    factory :basic_plan do
      sku Plan::THE_WEEKLY_ITERATION_SKU
      includes_exercises false
      includes_forum false
      includes_repositories false
      includes_video_tutorials false
    end

    trait :includes_mentor do
      includes_mentor true
    end

    trait :no_mentor do
      includes_mentor false
    end

    trait :team do
      individual_price 89
      name 'VideoTutorials for Teams'
      sku 'team_plan'
      includes_team true
    end

    trait :annual do
      name "#{I18n.t("shared.subscription.name")} (Yearly)"
      individual_price 990
      sku "professional-yearly"
      annual true
    end

    trait :with_annual_plan do
      association :annual_plan, factory: [:plan, :annual]
    end
  end

  factory :invitation, class: 'Invitation' do
    email
    sender factory: :user
    team

    after :stub do |invitation|
      invitation.code = 'abc'
    end

    trait :accepted do
      recipient factory: :user
      accepted_at { Time.now }
    end
  end

  factory :acceptance, class: 'Acceptance' do
    github_username
    invitation
    name
    password 'secret'

    initialize_with do
      new(invitation: invitation, attributes: attributes.except(:invitation))
    end
  end

  factory :product_license do
    discounted false
    offering_type 'VideoTutorial'
    original_price 10
    price 10
    product_id 123
    sku 'video_tutorial_1'
    variant 'individual'
    initialize_with { new(attributes) }
  end

  factory :team, class: 'Team' do
    name 'Google'
    association :subscription, factory: :team_subscription
  end

  factory :license do
    user
    association :licenseable, factory: :video_tutorial
  end

  factory :checkout do
    email
    name
    github_username
    association :plan, factory: :plan
    association :user, :with_stripe, :with_mentor, :with_github
  end

  factory :teacher do
    user
    video_tutorial
  end

  factory :topic do
    keywords 'clean, clear, precise'
    name
    summary 'short yet descriptive'

    trait :explorable do
      explorable true
    end
    trait :featured do
      featured true
    end
  end

  factory :legacy_trail do
    slug 'trail'
    topic
  end

  factory :completion do
    trail_object_id '2f720eaa8bcd602a7dc731feb224ff99bb85a03c'
    trail_name 'Git'
    user

    trait :previous_week do
      created_at Time.zone.local(2013, 'jul', 29)
    end

    trait :current_week do
      created_at Time.zone.local(2013, 'aug', 5)
    end
  end

  factory :mentor do
    association :user, :with_github, factory: :admin
  end

  factory :user do
    email
    name 'Dan Deacon'
    password 'password'

    transient do
      subscription nil
    end

    factory :admin do
      admin true
    end

    factory :subscriber do
      with_subscription

      factory :basic_subscriber do
        plan { create(:basic_plan) }
      end

      trait :includes_mentor do
        transient do
          plan { create(:plan, :includes_mentor) }
        end
      end
    end

    trait :with_github do
      github_username
    end

    trait :with_github_auth do
      github_username
      auth_provider 'github'
      auth_uid 1
    end

    trait :with_stripe do
      stripe_customer_id 'cus12345'
    end

    trait :with_subscription do
      with_mentor
      with_github
      stripe_customer_id 'cus12345'

      transient do
        plan { create(:plan) }
      end

      after :create do |instance, attributes|
        instance.subscriptions << create(
          :subscription,
          plan: attributes.plan,
          user: instance
        )
      end
    end

    trait :with_subscription_purchase do
      with_subscription

      after :create do |instance, attributes|
        instance.subscriptions << create(
          :subscription,
          :purchased,
          plan: attributes.plan,
          user: instance
        )
      end
    end

    trait :with_basic_subscription do
      with_github
      stripe_customer_id 'cus12345'

      after :create do |instance|
        plan = create(:basic_plan)
        create(:subscription, plan: plan, user: instance)
      end
    end

    trait :with_inactive_subscription do
      with_mentor
      with_github
      stripe_customer_id "cus12345"

      after :create do |instance|
        instance.subscriptions <<
          create(:inactive_subscription, user: instance)
      end
    end

    trait :with_inactive_team_subscription do
      with_mentor
      with_github
      stripe_customer_id 'cus12345'
      team

      after :create do |instance|
        create(
          :inactive_subscription,
          user: instance,
          plan: create(:plan, :team),
          team: instance.team
        )
      end
    end

    trait :with_team_subscription do
      with_mentor
      with_github
      stripe_customer_id 'cus12345'
      team

      after :create do |instance|
        subscription = create(
          :subscription,
          user: instance,
          plan: create(:plan, :team),
          team: instance.team
        )
        SubscriptionFulfillment.new(instance, subscription.plan).fulfill
      end
    end

    trait :with_mentor do
      mentor
    end
  end

  factory :subscription, aliases: [:active_subscription] do
    association :plan
    association :user, :with_stripe, :with_mentor, :with_github

    factory :inactive_subscription do
      deactivated_on { Time.zone.today }
    end

    factory :team_subscription do
      association :plan, factory: [:plan, :team]
    end

    trait :purchased do
      after :create do |subscription|
        create(
          :checkout,
          plan: subscription.plan,
          user: subscription.user
        )
      end
    end
  end

  factory :video do
    association :watchable, factory: :video_tutorial
    title
    wistia_id '1194803'
    published_on { 1.day.from_now }

    trait :published do
      published_on { 1.day.ago }
    end

    trait :with_preview do
      preview_wistia_id '1194804'
    end
  end

  factory :exercise do
    transient do
      slug { title.downcase.gsub(/\s+/, "-") }
    end

    summary "Exercise summary"
    sequence(:title) { |n| "Exercise #{n}" }
    url { "http://localhost:7000/exercises/#{slug}" }
    uuid

    trait :public do
      public true
    end
  end

  factory :oauth_access_token, class: "Doorkeeper::AccessToken" do
    transient do
      user nil
    end

    resource_owner_id { user.try(:id) }
    application_id 1
    token 'abc123'

    trait :with_application do
      association :application, factory: :oauth_application
    end
  end

  factory :oauth_application, class: "Doorkeeper::Application" do
    sequence(:name) { |n| "Application #{n}" }
    sequence(:uid) { |n| n }
    redirect_uri "http://www.example.com/callback"
  end

  factory :status do
    user
    association :completeable, factory: :exercise
  end

  factory :trail do
    name "Trail name"
    description "Trail description"
    complete_text "Way to go!"
    topic

    trait :published do
      published true
    end
  end

  factory :step do
    exercise
    trail
    sequence(:position) { |n| n }
  end
end
