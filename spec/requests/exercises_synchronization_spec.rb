require "rails_helper"

describe "PUT /api/v1/exercises/:id" do
  context "when an exercise with a given uuid does not exist" do
    it "creates a new exercise" do
      perform_request("uuid-1234", exercise_attributes)

      expect(response.status).to eq 200
      expect(Exercise.count).to eq 1

      exercise = Exercise.first
      expect(exercise.title).to eq exercise_attributes[:title]
      expect(exercise.uuid).to eq "uuid-1234"
      expect(exercise.url).to eq exercise_attributes[:url]
      expect(exercise.summary).to eq exercise_attributes[:summary]
    end
  end

  context "when an exercise with given uuid exists" do
    it "updates the exercise" do
      create(:exercise, title: "Old Title", uuid: "uuid-1234")

      perform_request("uuid-1234", exercise_attributes)

      expect(response.status).to eq 200
      expect(Exercise.count).to eq 1

      exercise = Exercise.first
      expect(exercise.title).to eq exercise_attributes[:title]
    end
  end

  def perform_request(uuid, attributes)
    put(
      "/api/v1/exercises/#{uuid}",
      access_token: access_token,
      exercise: attributes
    )
  end

  def access_token
    create(:oauth_access_token, :with_application).token
  end

  def exercise_attributes
    {
      title: "Shakespeare Analyzer",
      url: "https://exercise.upcase.com/exercises/shakespeare-analyzer",
      summary: "Analyse Shakespeare's literature"
    }
  end
end
