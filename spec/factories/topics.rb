FactoryBot.define do
  factory :topic do
    sequence(:name) { |n| "Topic #{n}" }
    page_title { "Learn #{name}" }
    summary { "short yet descriptive" }

    trait :explorable do
      explorable { true }
    end

    after :stub do |topic|
      topic.slug ||= topic.name.parameterize
    end
  end
end
