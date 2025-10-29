FactoryBot.define do
  factory :product, traits: [:active], class: "Show" do
    sequence(:name) { |n| "Product #{n}" }
    description { "Solve 8-Queens over and over again" }
    sequence(:tagline) { |n| "Product tagline #{n}" }
    sku { "TEST" }

    trait :active do
      active { true }
    end

    trait :inactive do
      active { false }
    end

    trait :promoted do
      promoted { true }
    end

    factory :show, class: "Show" do
      factory :the_weekly_iteration do
        name { Show::THE_WEEKLY_ITERATION }
      end
    end

    factory :repository, class: "Repository" do
      github_repository { "thoughtbot/upcase" }
      github_url { "https://github.com/thoughtbot/upcase" }
    end

    after(:stub) { |product| product.slug = product.name.parameterize }
  end
end
