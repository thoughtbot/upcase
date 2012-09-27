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

  factory :user do
    first_name 'Dan'
    last_name  'Deacon'
    email
    password "password"

    factory :admin do
      admin true
    end
  end

  factory :audience do
    name "Web Designer"
  end

  factory :course do
    audience
    name              { generate(:name) }
    description       "Solve 8-Queens over and over again"
    short_description "Solve 8-Queens"
    price       "500"
    start_at    '9:00'
    stop_at     '17:00'
    maximum_students 12

    factory :private_course do
      public false
    end
  end

  factory :section_without_teacher, class: Section do
    association :course
    starts_on { 1.day.ago }
    ends_on   { 1.day.from_now }
    start_at    '9:00'
    stop_at     '17:00'
    address     '41 Winter St'

    factory :section do
      after(:build) do |s|
        s.teachers << build(:teacher)
      end

      factory :future_section do
        starts_on { 2.days.from_now }
        ends_on   { 4.days.from_now }
      end
    end
  end

  factory :registration, aliases: [:unpaid_registration] do
    first_name 'Dan'
    last_name  'Deacon'
    organization 'company'
    email
    billing_email 'billing@example.com'
    section

    factory :paid_registration do
      paid true
    end

    factory :registration_with_all_attributes do
      phone '617 123 1234'
      address1 '123 Main St.'
      address2 'Apartment 6'
      city 'Boston'
      state 'MA'
      zip_code '02108'
    end
  end

  factory :teacher do
    name  "Billy Madison"
    email "bmadison@example.com"
  end

  factory :section_teacher do
    section
    teacher
  end

  factory :question do
    course
    question "What's up, buddy?"
    answer   "Not much, bro."
  end

  factory :follow_up do
    course
  end

  factory :coupon do
    code
    discount_type "percentage"
    amount 10

    factory :one_time_coupon do
      one_time_use_only true
    end
  end

  factory :product do
    name { generate(:name) }
    sku "TEST"
    individual_price 15
    company_price 50
    fulfillment_method "fetch"

    factory :book_product do
      product_type 'book'
    end

    factory :video_product do
      product_type 'video'
    end
  end

  factory :video do
    product
    wistia_id "1194803"
  end

  factory :download do
  end

  factory :purchase, aliases: [:individual_purchase] do
    product
    name "Test User"
    email "joe@example.com"
    variant "individual"

    factory :stripe_purchase do
      payment_method "stripe"
    end

    factory :free_purchase do
      payment_method "free"
      paid_price 0
     end
  end

  factory :article do
    author
    title
    tumblr_url
    published_on Date.today
    body_html 'article body'
  end

  factory :author do
    tumblr_user_name
  end

  factory :topic do
    name

    keywords 'clean, clear, precise'
    summary 'short yet descriptive'
  end

  factory :classification do
    topic
    association :classifiable, factory: :article
  end
end
