FactoryBot.define do
  factory :trail do
    sequence(:name) { |n| "Trail number #{n}" }
    description { "Trail description" }
    complete_text { "Way to go!" }

    trait :with_topic do
      after(:build) do |trail|
        trail.topics = [build(:topic)]
      end
    end

    trait :published do
      published { true }
    end

    trait :promoted do
      promoted { true }
    end

    trait :unpublished do
      published { false }
    end

    trait :completed do
      after :create do |instance|
        Timecop.travel(1.week.ago) do
          create(:status, :completed, completeable: instance)
        end
      end
    end

    trait :video do
      after :create do |trail|
        video = create(:video, watchable: nil)
        create(:step, trail: trail, completeable: video)
      end
    end

    trait :with_sample_video do
      after :create do |trail|
        video = create(:video, watchable: nil)
        create(:step, trail: trail, completeable: video)
      end
    end
  end
end
