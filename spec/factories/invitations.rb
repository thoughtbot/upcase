FactoryBot.define do
  factory :invitation, class: "Invitation" do
    sequence(:email) { |n| "invitee#{n}@example.com" }
    sender factory: :user
    team

    after :stub do |invitation|
      invitation.code = "abc"
    end

    trait :accepted do
      recipient factory: :user
      accepted_at { Time.current }
    end
  end
end
