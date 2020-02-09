FactoryBot.use_parent_strategy = false

FactoryBot.define do
  sequence :bio do |n|
    "The Amazing Brian the #{n}th"
  end

  sequence :code do |n|
    "code#{n}"
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :name do |n|
    "name #{n}"
  end

  sequence :uuid do |n|
    "uuid_#{n}"
  end

  sequence :github_username do |n|
    "github_#{n}"
  end

  sequence :tagline do |n|
    "tagline #{n}"
  end

  sequence :title do |n|
    "title #{n}"
  end

  sequence :external_url do |n|
    "http://robots.thoughtbot.com/#{n}"
  end

  factory :classification do
    association :classifiable, factory: :product
    topic
  end

  factory :product, traits: [:active], class: "Show" do
    after(:stub) { |product| product.slug = product.name.parameterize }
    description { 'Solve 8-Queens over and over again' }
    tagline

    trait :active do
      active { true }
    end

    trait :inactive do
      active { false }
    end

    trait :promoted do
      promoted { true }
    end

    name { generate(:name) }
    sku { 'TEST' }

    factory :show, class: 'Show' do
      factory :the_weekly_iteration do
        name { Show::THE_WEEKLY_ITERATION }
      end
    end

    factory :repository, class: 'Repository' do
      github_repository { "thoughtbot/upcase" }
      github_url { "https://github.com/thoughtbot/upcase" }
    end
  end

  factory :invitation, class: 'Invitation' do
    email
    sender factory: :user
    team

    after :stub do |invitation|
      invitation.code = 'abc'
    end

    trait :accepted do
      recipient factory: :user
      accepted_at { Time.current }
    end
  end

  factory :team, class: 'Team' do
    owner factory: :user
    name { 'Google' }
  end

  factory :teacher do
    user
    video
  end

  factory :topic do
    name
    page_title { "Learn #{name}" }
    summary { 'short yet descriptive' }

    trait :explorable do
      explorable { true }
    end

    after :stub do |topic|
      topic.slug ||= topic.name.parameterize
    end
  end

  factory :user do
    email
    name
    password { 'password' }
    github_username

    factory :admin do
      admin { true }
    end

    trait :admin do
      admin { true }
    end

    trait :with_github do
      github_username
    end

    trait :with_attached_team do
      team
      after(:create) do |user|
        user.team.update(owner: user)
      end
    end

    trait :with_github_auth do
      github_username
      auth_provider { "github" }
      auth_uid { 1 }
    end
  end

  factory :video, aliases: [:recommendable] do
    association :watchable, factory: :show
    sequence(:name) { |n| "Video #{n}" }
    wistia_id { '1194803' }
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

  factory :exercise do
    transient do
      slug { name.downcase.gsub(/\s+/, "-") }
    end

    summary { "Exercise summary" }
    sequence(:name) { |n| "Exercise #{n}" }
    url { "http://localhost:7000/exercises/#{slug}" }
    uuid
  end

  factory :oauth_access_token, class: "Doorkeeper::AccessToken" do
    transient do
      user { nil }
    end

    resource_owner_id { user.try(:id) }
    application_id { 1 }
    token { 'abc123' }

    trait :with_application do
      association :application, factory: :oauth_application
    end
  end

  factory :oauth_application, class: "Doorkeeper::Application" do
    sequence(:name) { |n| "Application #{n}" }
    sequence(:uid) { |n| n }
    redirect_uri { "http://www.example.com/callback" }
  end

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

  factory :step do
    association :completeable, factory: :exercise
    trail
    sequence(:position) { |n| n }
  end

  factory :deck do
    title
    published { true }
  end

  factory :flashcard do
    sequence(:title) { |n| "Flashcard Title #{n}" }
    prompt { "How could you avoid testing for nil in these lines" }
    answer { "Use the Null Object pattern!" }
    deck
  end

  factory :attempt do
    confidence { 3 }
    flashcard
    user
  end

  factory :marker do
    video
    anchor { "configuration-options" }
    time { 322 }
  end

  factory :content_recommendation do
    recommendable
    user
  end

  factory :recommendable_content do
    sequence(:position)
    recommendable
  end
end
