require "rails_helper"

describe Api::V1::ExercisesController do
  describe "#update" do
    it "returns a 401 when client is not authenticated" do
      put :update, id: "uuid-1234"

      expect(response.code).to eq "401"
    end

    it "returns a 401 when token is associated with a resource owner" do
      access_token = build_stubbed(:oauth_access_token, resource_owner_id: 1)
      authenticate_with(access_token)

      put :update, id: "uuid-1234"

      expect(response.code).to eq "401"
    end

    it "returns a 422 when request was made with invalid attributes" do
      access_token = build_stubbed(:oauth_access_token, resource_owner_id: nil)
      authenticate_with(access_token)
      errors = "errors"
      exercise = stub("exercise", update_attributes: false, errors: errors)
      Exercise.stubs(find_or_initialize_by: exercise)

      put :update, id: "uuid-1234", exercise: { title: "", url: "" }

      expect(response.status).to eq 422
      expect(response.body).to eq({ errors: errors }.to_json)
    end

    def authenticate_with(access_token)
      Doorkeeper::OAuth::Token.stubs(:authenticate).returns(access_token)
    end
  end
end
