FactoryBot.define do
  factory :attempt do
    confidence { 3 }
    flashcard
    user
  end
end
