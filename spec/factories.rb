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

  factory :audience do
    name 'Web Designer'
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

  factory :course do
    audience
    description 'Solve 8-Queens over and over again'
    maximum_students 12
    name { generate(:name) }
    price '500'
    short_description 'Solve 8-Queens'
    start_at '9:00'
    stop_at '17:00'

    factory :private_course do
      public false
    end
  end

  factory :download do
  end

  factory :follow_up do
    course
  end

  factory :question do
    answer 'Not much, bro.'
    course
    question "What's up, buddy?"
  end

  factory :product do
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
  end

  factory :purchase, aliases: [:individual_purchase] do
    email 'joe@example.com'
    name 'Test User'
    product
    variant 'individual'

    factory :stripe_purchase do
      payment_method 'stripe'
    end

    factory :free_purchase do
      paid_price 0
      payment_method 'free'
     end
  end

  factory :registration, aliases: [:unpaid_registration] do
    billing_email 'billing@example.com'
    email
    first_name 'Dan'
    last_name 'Deacon'
    organization 'company'
    section

    factory :paid_registration do
      paid true
    end

    factory :registration_with_all_attributes do
      address1 '123 Main St.'
      address2 'Apartment 6'
      city 'Boston'
      phone '617 123 1234'
      state 'MA'
      zip_code '02108'
    end
  end

  factory :section_teacher do
    section
    teacher
  end

  factory :section_without_teacher, class: Section do
    address '41 Winter St'
    association :course
    ends_on { 1.day.from_now }
    start_at '9:00'
    starts_on { 1.day.ago }
    stop_at '17:00'

    factory :section do
      after(:build) do |s|
        s.teachers << build(:teacher)
      end

      factory :future_section do
        ends_on { 4.days.from_now }
        starts_on { 2.days.from_now }
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
    product
    wistia_id '1194803'
  end
end
