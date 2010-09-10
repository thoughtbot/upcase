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
end

Factory.define(:section) do |section_factory|
  section_factory.association :course
  section_factory.starts_on { 1.day.ago }
  section_factory.ends_on { 1.day.from_now }
  section_factory.after_build {|s|
    s.section_teachers << Factory.build(:section_teacher, :section => s)
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
