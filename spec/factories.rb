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

  sequence :title do |n|
    "title #{n}"
  end

  sequence :external_url do |n|
    "http://robots.thoughtbot.com/#{n}"
  end

  factory :announcement do
    association :announceable, factory: :book
    ends_at { 1.day.from_now }
    message 'Foo: http://example.com'
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

  factory :workshop do
    description 'Solve 8-Queens over and over again'
    name { generate(:name) }
    short_description 'Solve 8-Queens'
    sku 'EIGHTQUEENS'
    length_in_days 28

    factory :private_workshop do
      active false
    end

    trait :active do
      active true
    end

    trait :inactive do
      active false
    end

    trait :promoted do
      promoted true
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
    workshop
  end

  factory :public_key do
    data 'ssh-rsa abc123hexadecimal'
  end

  factory :product, traits: [:active], class: 'Book' do
    trait :active do
      active true
    end

    trait :inactive do
      active false
    end

    trait :promoted do
      promoted true
    end

    trait :github do
      github_team 9999
      github_url 'http://github.com/thoughtbot/book-repo'
    end

    company_price 50
    individual_price 15
    name { generate(:name) }
    sku 'TEST'

    factory :book, class: 'Book' do
    end

    factory :screencast, class: 'Screencast' do
    end

    factory :show, class: 'Show' do
    end
  end

  factory :individual_plan, aliases: [:plan] do
    name 'Prime'
    individual_price 99
    sku 'prime'
    short_description 'A great Subscription'
    description 'A long description'

    factory :basic_plan do
      sku IndividualPlan::PRIME_BASIC_SKU
      includes_workshops false
    end

    trait :includes_mentor do
      includes_mentor true
    end
  end

  factory :invitation, class: 'Teams::Invitation' do
    email
    sender factory: :user
    team

    after :stub do |invitation|
      invitation.code = 'abc'
    end
  end

  factory :acceptance, class: 'Teams::Acceptance' do
    github_username 'username'
    invitation
    name
    password 'secret'

    initialize_with { new(invitation, attributes.except(:invitation)) }
  end

  factory :product_license do
    discounted false
    offering_type 'Book'
    original_price 10
    price 10
    product_id 123
    sku 'book1'
    variant 'individual'
    initialize_with { new(attributes) }
  end

  factory :team_plan, class: 'Teams::TeamPlan' do
    individual_price 89
    name 'Workshops for Teams'
    sku 'team_plan'
  end

  factory :team, class: 'Teams::Team' do
    name 'Google'
    subscription
    max_users 10
  end

  factory :purchase, aliases: [:individual_purchase] do
    email
    name
    association :purchaseable, factory: :book
    variant 'individual'

    trait :free do
      paid_price 0
      payment_method 'free'
    end

    factory :paid_purchase do
      paid true
    end

    factory :unpaid_purchase do
      paid false

      after(:create) do |purchase|
        purchase.paid = false
        purchase.save!
      end
    end

    factory :stripe_purchase do
      payment_method 'stripe'
    end

    factory :free_purchase, traits: [:free]

    factory :workshop_purchase do
      association :purchaseable, factory: :workshop
    end

    factory :book_purchase do
      association :purchaseable, factory: :book
    end

    factory :screencast_purchase do
      association :purchaseable, factory: :screencast
    end

    factory :plan_purchase do
      association :purchaseable, factory: :plan
      association :user, :with_stripe, :with_mentor, :with_github
    end
  end

  factory :teacher do
    user
    workshop
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

      trait :includes_mentor do
        ignore do
          plan { create(:individual_plan, :includes_mentor) }
        end
      end
    end

    trait :with_github do
      github_username 'thoughtbot'
    end

    trait :with_github_auth do
      github_username 'thoughtbot'
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
        instance.purchased_subscription =
          create(:subscription, plan: attributes.plan, user: instance)
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
      stripe_customer_id 'cus12345'

      after :create do |instance|
        create(:inactive_subscription, user: instance)
      end
    end

    trait :with_team_subscription do
      with_mentor
      with_github
      stripe_customer_id 'cus12345'

      after :create do |instance|
        create(
          :subscription,
          user: instance,
          plan: create(:team_plan)
        )
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
  end

  factory :video do
    association :watchable, factory: :product
    title
    wistia_id '1194803'
    published_on { 1.day.from_now }

    trait :published do
      published_on { 1.day.ago }
    end
  end

  factory :exercise do
    title
    url 'http://www.example.com'
    description 'Exercise description'
  end

  factory :oauth_access_token do
    application_id 1
    token 'abc123'
  end
end
