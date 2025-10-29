FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "User #{n}" }
    password { "password" }
    sequence(:github_username) { |n| "github_user_#{n}" }

    factory :admin do
      admin { true }
    end

    trait :admin do
      admin { true }
    end

    trait :with_github do
      sequence(:github_username) { |n| "with_github_user_#{n}" }
    end

    trait :with_attached_team do
      team
      after(:create) do |user|
        user.team.update(owner: user)
      end
    end

    trait :with_github_auth do
      sequence(:github_username) { |n| "with_github_auth_user_#{n}" }
      auth_provider { "github" }
      auth_uid { 1 }
    end
  end
end
