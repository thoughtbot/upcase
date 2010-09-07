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

Factory.define(:course) do |course_factory|
end

Factory.define(:section) do |section_factory|
  section_factory.association :course
end

Factory.define(:registration) do |registration_factory|
  registration_factory.association :section
  registration_factory.association :user
end
