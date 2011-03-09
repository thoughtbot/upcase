Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :code do |n|
  "code#{n}"
end

Factory.define :user do |user|
  user.email                 { Factory.next :email }
  user.password              "password"
  user.password_confirmation "password"
  user.first_name "Dan"
  user.last_name "Deacon"
end

Factory.define :email_confirmed_user, :parent => :user do |user|
  user.email_confirmed { true }
end

Factory.define(:admin, :parent => :email_confirmed_user) do |user_factory|
  user_factory.admin true
end

Factory.define(:course) do |course_factory|
  course_factory.name        "Test-Driven Prolog"
  course_factory.description "Solve 8-Queens over and over again"
  course_factory.price       "500"
  course_factory.start_at    '9:00'
  course_factory.stop_at     '17:00'
  course_factory.location    '41 Winter St Boston, MA'
  course_factory.maximum_students 12
end

Factory.define(:section) do |section_factory|
  section_factory.association :course
  section_factory.starts_on { 1.day.ago }
  section_factory.ends_on { 1.day.from_now }
  section_factory.after_build {|s|
    s.teachers << Factory.build(:teacher)
  }
end

Factory.define(:registration) do |registration_factory|
  registration_factory.association :section
  registration_factory.association :user
end

Factory.define(:teacher) do |teacher_factory|
  teacher_factory.name  "Billy Madison"
  teacher_factory.email "bmadison@example.com"
end

Factory.define(:section_teacher) do |section_teacher_factory|
  section_teacher_factory.association :section
  section_teacher_factory.association :teacher
end

Factory.define(:question) do |question_factory|
  question_factory.association :course
  question_factory.question    "What's up, buddy?"
  question_factory.answer      "Not much, bro."
end

Factory.define(:resource) do |resource_factory|
  resource_factory.association :course
end

Factory.define(:follow_up) do |factory|
  factory.association :course
end

Factory.define(:coupon) do |factory|
  factory.code       { Factory.next :email }
  factory.percentage 10
end
