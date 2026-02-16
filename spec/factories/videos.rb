FactoryBot.define do
  factory :video, aliases: [:recommendable] do
    association :watchable, factory: :show
    sequence(:name) { |n| "Video #{n}" }
    wistia_id { "1194803" }
    published_on { 1.day.from_now }

    trait :published do
      published_on { 1.day.ago }
    end

    trait :with_trail do
      after :create do |video|
        create(:step, trail: create(:trail), completeable: video)
      end
    end

    trait :with_progress do
      state { Status::UNSTARTED }

      initialize_with do
        CompleteableWithProgress.new(new(attributes.except(:state)), state)
      end
    end

    trait :with_preview do
      sequence(:preview_wistia_id) { |n| "preview-#{n}" }
    end

    after(:stub) { |video| video.slug = video.id.to_s }
  end
end
