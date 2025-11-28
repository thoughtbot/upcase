FactoryBot.define do
  factory :status do
    user
    association :completeable, factory: :exercise

    trait :in_progress do
      state { Status::IN_PROGRESS }
    end

    trait :completed do
      state { Status::COMPLETE }
    end
  end
end
