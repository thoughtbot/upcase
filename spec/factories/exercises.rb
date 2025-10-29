FactoryBot.define do
  factory :exercise do
    transient do
      slug { name.downcase.gsub(/\s+/, "-") }
    end

    summary { "Exercise summary" }
    sequence(:name) { |n| "Exercise #{n}" }
    url { "http://localhost:7000/exercises/#{slug}" }
    sequence(:uuid) { |n| "exercise_uuid_#{n}" }
  end
end
