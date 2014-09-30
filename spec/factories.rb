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

  trait :in_dashboard do
    after :create do |classifiable|
      topic = create(:topic, dashboard: true)
      classifiable.classifications.create!(topic: topic)
    end
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

  factory :question do
    answer 'Not much, bro.'
    question "What's up, buddy?"
    video_tutorial
  end

  factory :public_key do
    data 'ssh-rsa abc123hexadecimal'
  end

  factory :product, traits: [:active], class: "VideoTutorial" do
    after(:stub) { |product| product.slug = product.name.parameterize }
    description 'Solve 8-Queens over and over again'
    length_in_days 28
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
      github_url "http://github.com/thoughtbot/upcase"
    end
  end

  factory :plan do
    name I18n.t("shared.subscription.name")
    individual_price 99
    sku "prime-99"
    short_description 'A great Subscription'
    description 'A long description'

    factory :basic_plan do
      sku Plan::PRIME_29_SKU
      includes_exercises false
      includes_forum false
      includes_office_hours false
      includes_source_code false
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

    initialize_with { new(invitation, attributes.except(:invitation)) }
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
    association :subscribeable, factory: :plan
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

    trait :featured do
      featured true
    end
  end

  factory :trail do
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
    purchased_subscription { subscription }

    ignore do
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
        ignore do
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

      ignore do
        plan { create(:plan) }
      end

      after :create do |instance, attributes|
        instance.purchased_subscription = create(
          :subscription,
          plan: attributes.plan,
          user: instance
        )
      end
    end

    trait :with_subscription_purchase do
      with_subscription

      after :create do |instance, attributes|
        instance.purchased_subscription = create(
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
        instance.purchased_subscription =
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
          subscribeable: subscription.plan,
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
    summary "Exercise summary"
    title
    url "http://www.example.com"
    uuid
  end

  factory :oauth_access_token do
    application_id 1
    token 'abc123'
  end

  factory :status do
    user
    exercise
  end
end
