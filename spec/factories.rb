FactoryGirl.define do
  sequence :bio do |n|
    "The Amazing Brian the #{n}th"
  end

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

  sequence :tagline do |n|
    "tagline #{n}"
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

  factory :beta_offer, class: "Beta::Offer" do
    name
    active true
    description "A great trail"
  end

  factory :beta_reply, class: "Beta::Reply" do
    association :offer, factory: :beta_offer
    user
    accepted true
  end

  factory :coupon do
    transient do
      code
      amount_off 2500
      duration "forever"
      duration_in_months nil
      percent_off nil
    end

    initialize_with { new(code) }
    to_create {}

    after(:create) do |_, attributes|
      Stripe::Coupon.create(
        id: attributes.code,
        amount_off: attributes.amount_off,
        duration: attributes.duration,
        duration_in_months: attributes.duration_in_months,
        percent_off: attributes.percent_off,
      )
    end
  end

  factory :note do
    body 'Default note body'
    user
    contributor { user }

    trait :current_week do
      created_at Time.zone.local(2013, 'aug', 5)
    end
  end

  factory :product, traits: [:active], class: "Show" do
    after(:stub) { |product| product.slug = product.name.parameterize }
    description 'Solve 8-Queens over and over again'
    tagline

    trait :active do
      active true
    end

    trait :inactive do
      active false
    end

    trait :promoted do
      promoted true
    end

    name { generate(:name) }
    sku 'TEST'

    factory :show, class: 'Show' do
      factory :the_weekly_iteration do
        name Show::THE_WEEKLY_ITERATION
      end
    end

    factory :repository, class: 'Repository' do
      github_repository "thoughtbot/upcase"
      github_url "https://github.com/thoughtbot/upcase"
    end
  end

  factory :plan do
    name I18n.t("shared.subscription.name")
    price_in_dollars 99
    sku Plan::PROFESSIONAL_SKU
    short_description 'A great Subscription'
    description 'A long description'
    includes_trails true

    factory :basic_plan do
      sku Plan::THE_WEEKLY_ITERATION_SKU
      includes_trails false
      includes_forum false
      includes_repositories false
    end

    factory :discounted_annual_plan do
      sku Plan::DISCOUNTED_ANNUAL_PLAN_SKU
      annual true
    end

    trait :featured do
      featured true
    end

    trait :includes_repositories do
      includes_repositories true
    end

    trait :no_repositories do
      includes_repositories false
    end

    trait :team do
      price_in_dollars 89
      name "Upcase for Teams"
      sku "team_plan"
      includes_team true
      minimum_quantity 3
    end

    trait :annual do
      name "#{I18n.t("shared.subscription.name")} (Yearly)"
      price_in_dollars 990
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

  factory :team, class: 'Team' do
    name 'Google'
    association :subscription, factory: :team_subscription
  end

  factory :checkout do
    email
    name
    github_username
    association :plan, factory: :plan
    association :user, :with_stripe, :with_github
  end

  factory :teacher do
    user
    video
  end

  factory :topic do
    keywords 'clean, clear, precise'
    name
    page_title { "Learn #{name}" }
    summary 'short yet descriptive'

    trait :explorable do
      explorable true
    end

    after :stub do |topic|
      topic.slug ||= topic.name.parameterize
    end
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

  factory :user do
    email
    name
    password 'password'
    github_username

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

      trait :onboarded do
        completed_welcome true
      end

      trait :needs_onboarding do
        completed_welcome false
      end

      trait :admin do
        admin true
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

    trait :with_full_subscription do
      with_subscription

      transient do
        plan do
          create(
            :plan,
            includes_trails: true,
            includes_forum: true,
            includes_repositories: true
          )
        end
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
      with_github
      stripe_customer_id "cus12345"

      after :create do |instance|
        instance.subscriptions <<
          create(:inactive_subscription, user: instance)
      end
    end

    trait :with_inactive_team_subscription do
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
  end

  factory :subscription, aliases: [:active_subscription] do
    association :plan
    association :user, :with_stripe, :with_github

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
    association :watchable, factory: :show
    sequence(:name) { |n| "Video #{n}" }
    wistia_id '1194803'
    published_on { 1.day.from_now }

    trait :published do
      published_on { 1.day.ago }
    end

    trait :with_trail do
      after :create do |video|
        create(:step, trail: create(:trail), completeable: video)
      end
    end

    trait :with_progress do
      state { Status::UNSTARTED }

      initialize_with do
        CompleteableWithProgress.new(new(attributes.except(:state)), state)
      end
    end

    trait :free_sample do
      accessible_without_subscription true
    end

    trait :with_preview do
      sequence(:preview_wistia_id) { |n| "preview-#{n}" }
    end

    after(:stub) { |video| video.slug = video.id.to_s }
  end

  factory :exercise do
    transient do
      slug { name.downcase.gsub(/\s+/, "-") }
    end

    summary "Exercise summary"
    sequence(:name) { |n| "Exercise #{n}" }
    url { "http://localhost:7000/exercises/#{slug}" }
    uuid
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

    trait :in_progress do
      state Status::IN_PROGRESS
    end

    trait :completed do
      state Status::COMPLETE
    end
  end

  factory :trail do
    sequence(:name) { |n| "Trail number #{n}" }
    description "Trail description"
    complete_text "Way to go!"
    topic

    trait :published do
      published true
    end

    trait :unpublished do
      published false
    end

    trait :completed do
      after :create do |instance|
        Timecop.travel(1.week.ago) do
          create(:status, :completed, completeable: instance)
        end
      end
    end

    trait :video do
      after :create do |trail|
        video = create(:video, watchable: nil)
        create(:step, trail: trail, completeable: video)
      end
    end
  end

  factory :step do
    association :completeable, factory: :exercise
    trail
    sequence(:position) { |n| n }
  end

  factory :deck do
    title
    published true
  end

  factory :flashcard do
    sequence(:title) { |n| "Flashcard Title #{n}" }
    prompt "How could you avoid testing for nil in these lines"
    answer "Use the Null Object pattern!"
    deck
  end

  factory :attempt do
    confidence 3
    flashcard
    user
  end

  factory :marker do
    anchor "configuration-options"
    time 322
  end
end
