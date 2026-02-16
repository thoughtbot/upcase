FactoryBot.define do
  factory :team, class: "Team" do
    # sequence(:name) { |n| "Team #{n}" }

    owner factory: :user
    name { "Google" }
  end
end
