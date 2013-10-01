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

  sequence :tumblr_user_name do |n|
    "user#{n}"
  end

  factory :alternate do
    ignore do
      key 'online_workshop'
      offering { build(:workshop) }
    end

    initialize_with { new(key, offering) }
  end

  factory :announcement do
    association :announceable, factory: :book_product
    ends_at { 1.day.from_now }
    message 'Foo: http://example.com'
  end

  factory :article do
    body_html 'article body'
    published_on Time.zone.today
    title
    external_url
  end

  factory :byte do
    body 'article body'
    body_html 'article body'
    published_on Time.zone.today
    title
  end

  factory :classification do
    association :classifiable, factory: :article
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
    maximum_students 12
    name { generate(:name) }
    short_description 'Solve 8-Queens'
    sku 'EIGHTQUEENS'

    factory :private_workshop do
      active false
    end

    factory :in_person_workshop do
      online false
    end

    factory :online_workshop do
      online true
      length_in_days 28
    end
  end

  factory :download

  factory :follow_up do
    email
    workshop
  end

  factory :note do
    body 'Default note body'
    user
    contributor { user }

    trait :current_week do
      created_at Time.local(2013, 'aug', 5)
    end
  end

  factory :question do
    answer 'Not much, bro.'
    question "What's up, buddy?"
    workshop
  end

  factory :product, traits: [:active] do
    trait :active do
      active true
    end

    trait :inactive do
      active false
    end

    company_price 50
    fulfillment_method 'fetch'
    individual_price 15
    name { generate(:name) }
    sku 'TEST'
    product_type 'test'

    factory :book_product do
      product_type 'book'
    end

    factory :github_book_product do
      product_type 'book'
      github_team 9999
      fulfillment_method 'github'
      github_url 'http://github.com/thoughtbot/book-repo'
    end

    factory :video_product do
      product_type 'video'
    end
  end

  factory :individual_plan, aliases: [:plan] do
    name 'Prime'
    individual_price 99
    sku 'prime'
    short_description 'A great Subscription'
    description 'A long description'

    factory :downgraded_plan do
      sku IndividualPlan::PRIME_BASIC_SKU
      includes_mentor false
      includes_workshops false
    end
  end

  factory :team_plan do
    sku 'team_plan'
    name 'Prime for Teams'
  end

  factory :team do
    name 'Google'
  end

  factory :purchase, aliases: [:individual_purchase] do
    email
    name 'Test User'
    association :purchaseable, factory: :product
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

    factory :section_purchase do
      association :purchaseable, factory: :section

      factory :in_person_section_purchase do
        association :purchaseable, factory: :in_person_section
      end

      factory :online_section_purchase do
        association :purchaseable, factory: :online_section
      end
    end

    factory :book_purchase do
      association :purchaseable, factory: :book_product
    end

    factory :video_purchase do
      association :purchaseable, factory: :video_product
    end

    factory :plan_purchase do
      association :purchaseable, factory: :plan
      association :user, :with_stripe, :with_mentor, :with_github
    end
  end

  factory :section_teacher do
    section
    teacher
  end

  factory :section_without_teacher, class: Section do
    association :workshop
    starts_on { 1.day.from_now.to_date }
    ends_on   { 2.days.from_now.to_date }
    start_at    '9:00'
    stop_at     '17:00'
    address     '41 Winter St'

    factory :section do
      after(:build) do |s|
        s.teachers << build(:teacher)
      end

      factory :future_section do
        starts_on { 2.days.from_now.to_date }
        ends_on   { 4.days.from_now.to_date }
      end

      factory :past_section do
        starts_on { 6.days.ago.to_date }
        ends_on   { 4.days.ago.to_date }
      end

      factory :in_person_section do
        association :workshop, factory: :in_person_workshop
      end

      factory :online_section do
        ends_on nil
        association :workshop, factory: :online_workshop
      end
    end
  end

  factory :teacher do
    email 'bmadison@example.com'
    name 'Billy Madison'
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
      created_at Time.local(2013, 'jul', 29)
    end

    trait :current_week do
      created_at Time.local(2013, 'aug', 5)
    end
  end

  factory :user do
    email
    name 'Dan Deacon'
    password 'password'

    factory :admin do
      admin true
    end

    factory :mentor do
      admin true
      available_to_mentor true
    end

    trait :with_github do
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

      after :create do |instance|
        create(:subscription, user: instance)
      end
    end

    trait :with_mentor do
      association :mentor, factory: :user
    end
  end

  factory :subscription, aliases: [:active_subscription] do
    association :plan
    association :user, :with_stripe, :with_mentor, :with_github

    factory :inactive_subscription do
      deactivated_on Time.zone.today
    end
  end

  factory :video do
    association :watchable, factory: :product
    wistia_id '1194803'
  end

  factory :show do
    credits 'Some people'
    description 'Some people talking'
    email
    itunes_url 'http://itunes.com'
    keywords 'design, development'
    short_description 'Weekly podcast of some people talking'
    slug 'giantrobots'
    title 'Talking Show'
  end

  factory :episode do
    show
    title 'Episode Title'
    description 'A really great episode'
    published_on { 1.day.ago }

    factory :future_episode do
      published_on { 1.day.from_now }
    end
  end

  factory :oauth_access_token do
    application_id 1
    token 'abc123'
  end
end
