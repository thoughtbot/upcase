FactoryBot.define do
  factory :step do
    association :completeable, factory: :exercise
    trail
    sequence(:position)
  end
end
