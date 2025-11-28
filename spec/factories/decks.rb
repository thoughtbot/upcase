FactoryBot.define do
  factory :deck do
    sequence(:title) { |n| "Deck title #{n}" }
    published { true }
  end
end
