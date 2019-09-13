require "rails_helper"

describe Api::V1::ExercisesController do
  describe "#update" do
    it "returns a 401 when client is not authenticated" do
      put :update, params: { id: "uuid-1234" }

      expect(response.code).to eq "401"
    end

    it "returns a 401 when token is associated with a resource owner" do
      access_token = build_stubbed(:oauth_access_token, resource_owner_id: 1)
      authenticate_with(access_token)

      put :update, params: { id: "uuid-1234" }

      expect(response.code).to eq "401"
    end

    it "returns a 422 when request was made with invalid attributes" do
      access_token = build_stubbed(:oauth_access_token, resource_owner_id: nil)
      authenticate_with(access_token)
      errors = "errors"
      exercise = double("exercise", update: false, errors: errors)
      allow(Exercise).to receive(:find_or_initialize_by).and_return(exercise)

      put :update, params: { id: "uuid-1234", exercise: { name: "", url: "" } }

      expect(response.status).to eq 422
      expect(response.body).to eq({ errors: errors }.to_json)
    end

    def authenticate_with(access_token)
      allow(Doorkeeper::OAuth::Token).to receive(:authenticate).
        and_return(access_token)
    end
  end
end
