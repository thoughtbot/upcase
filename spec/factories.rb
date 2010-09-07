Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |user|
  user.email                 { Factory.next :email }
  user.password              { "password" }
  user.password_confirmation { "password" }
end

Factory.define :email_confirmed_user, :parent => :user do |user|
  user.email_confirmed { true }
end

Factory.define :admin, :parent => :email_confirmed_user do |user_factory|
  user_factory.admin true
end

Factory.define(:course) do |course_factory|
  course_factory.name        "Test-Driven Prolog"
  course_factory.description "Solve 8-Queens over and over again"
  course_factory.price       "500"
  course_factory.start_at    '9:00'
  course_factory.stop_at     '17:00'
  course_factory.location    '41 Winter St Boston, MA'
end

Factory.define(:section) do |section_factory|
  section_factory.association :course
end

Factory.define(:registration) do |registration_factory|
  registration_factory.association :section
  registration_factory.association :user
end
