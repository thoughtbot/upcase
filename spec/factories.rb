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

  sequence :tumblr_url do |n|
    "http://robots.thoughtbot.com/#{n}"
  end

  sequence :tumblr_user_name do |n|
    "user#{n}"
  end

  factory :announcement do
    association :announceable, factory: :book_product
    ends_at { Time.now.tomorrow }
    message 'Foo: http://example.com'
  end

  factory :article do
    author
    body_html 'article body'
    published_on Date.today
    title
    tumblr_url
  end

  factory :author do
    tumblr_user_name
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
    individual_price '500'
    company_price '10000'
    short_description 'Solve 8-Queens'
    start_at '9:00'
    stop_at '17:00'

    factory :private_workshop do
      public false
    end

    factory :in_person_workshop do
      online false
    end

    factory :online_workshop do
      online true
    end
  end

  factory :download

  factory :follow_up do
    email
    workshop
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

    factory :book_product do
      product_type 'book'
    end

    factory :video_product do
      product_type 'video'
    end

    factory :workshop_product do
      product_type 'workshop'
    end

    factory :subscribeable_product do
      product_type 'subscription'
    end
  end

  factory :purchase, aliases: [:individual_purchase, :unpaid_purchase] do
    email 'joe@example.com'
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

      factory :in_person_section do
        association :workshop, factory: :in_person_workshop
      end

      factory :online_section do
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
  end

  factory :user do
    email
    first_name 'Dan'
    last_name 'Deacon'
    password 'password'

    factory :admin do
      admin true
    end
  end

  factory :video do
    association :watchable, factory: :product
    wistia_id '1194803'
  end

  factory :event do
    association :workshop
    title 'Office Hours'
    time '1pm Eastern'
  end

  factory :episode do
    title 'Episode Title'
    file_size 1000
    duration 2000
    file 'http://gr-podcast.s3.amazonaws.com/thoughtbot-020.mp3'
    description 'A really great episode'
    published_on { 1.day.ago }

    factory :future_episode do
      published_on { 1.day.from_now }
    end
  end
end
