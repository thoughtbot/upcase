FactoryBot.define do
  factory :classification do
    association :classifiable, factory: :product
    topic
  end
end
