FactoryGirl.define do
  sequence :code do |n|
    "code#{n}"
  end

  sequence :email do |n|
    "user#{n}@example.com"
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
    name              "Test-Driven Prolog"
    description       "Solve 8-Queens over and over again"
    short_description "Solve 8-Queens"
    price       "500"
    start_at    '9:00'
    stop_at     '17:00'
    location    '41 Winter St Boston, MA'
    maximum_students 12
  end

  factory :section do
    association :course
    starts_on { 1.day.ago }
    ends_on   { 1.day.from_now }
    start_at    '9:00'
    stop_at     '17:00'
    after_build do |s|
      s.teachers << FactoryGirl.build(:teacher)
    end
  end

  factory :registration do
    first_name 'Dan'
    last_name  'Deacon'
    organization 'company'
    email
    billing_email 'billing@example.com'
    section
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
    percentage 10
  end

  factory :product do
    name "Test Product"
    sku "TEST"
    individual_price 15
    company_price 50
    fulfillment_method "fetch"
  end

  factory :purchase do
    product
    name "Test User"
    email "joe@example.com"
    variant "individual"
    payment_method "stripe"
  end
end
