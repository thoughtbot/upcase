FactoryBot.define do
  factory :recommendable_content do
    sequence(:position)
    recommendable
  end
end
