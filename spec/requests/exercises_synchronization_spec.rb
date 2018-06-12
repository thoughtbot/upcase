require "rails_helper"

describe "PUT /upcase/api/v1/exercises/:id" do
  context "when an exercise with a given uuid does not exist" do
    it "creates a new exercise" do
      perform_request("uuid-1234", exercise_attributes)

      expect(response.status).to eq 200
      expect(Exercise.count).to eq 1

      exercise = Exercise.first
      expect(exercise.name).to eq exercise_attributes[:name]
      expect(exercise.uuid).to eq "uuid-1234"
      expect(exercise.url).to eq exercise_attributes[:url]
      expect(exercise.edit_url).to eq exercise_attributes[:edit_url]
      expect(exercise.summary).to eq exercise_attributes[:summary]
    end
  end

  context "when an exercise with given uuid exists" do
    it "updates the exercise" do
      create(:exercise, name: "Old Title", uuid: "uuid-1234")

      perform_request("uuid-1234", exercise_attributes)

      expect(response.status).to eq 200
      expect(Exercise.count).to eq 1

      exercise = Exercise.first
      expect(exercise.name).to eq exercise_attributes[:name]
    end
  end

  def perform_request(uuid, attributes)
    put(
      api_v1_exercise_path(uuid),
      params: {
        access_token: access_token,
        exercise: attributes,
      },
    )
  end

  def access_token
    create(:oauth_access_token, :with_application).token
  end

  def exercise_attributes
    {
      edit_url:
        "https://exercise.upcase.com/admin/exercises/shakespeare-analyzer/edit",
      name: "Shakespeare Analyzer",
      summary: "Analyse Shakespeare's literature",
      url: "https://exercise.upcase.com/exercises/shakespeare-analyzer"
    }
  end
end
