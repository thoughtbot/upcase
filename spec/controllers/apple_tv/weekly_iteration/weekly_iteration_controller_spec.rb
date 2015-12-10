require "rails_helper"

describe AppleTv::WeeklyIterationsController do
  describe "#index" do
    it "works" do
      get :index, format: :xml

      expect(response).to be_success
    end
  end
end
