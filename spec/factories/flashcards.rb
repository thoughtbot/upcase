FactoryBot.define do
  factory :flashcard do
    sequence(:title) { |n| "Flashcard Title #{n}" }
    prompt { "How could you avoid testing for nil in these lines" }
    answer { "Use the Null Object pattern!" }
    deck
  end
end
