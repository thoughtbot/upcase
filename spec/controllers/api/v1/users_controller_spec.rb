require "rails_helper"

describe Api::V1::UsersController do
  describe "#show" do
    context "authenticated" do
      it "serializes the user" do
        user = stub_oauth_authenticated_user
        expected_json = { user: UserSerializer.new(user).as_json }

        get :show, format: :json

        expect(controller).to respond_with(:success)
        expect(parsed_response_json).to eq(expected_json)
      end

      def parsed_response_json
        JSON.parse(response.body, symbolize_names: true)
      end
    end

    context "unauthenticated" do
      it "returns a 401" do
        get :show
        expect(response.code).to eq "401"
      end
    end
  end
end
