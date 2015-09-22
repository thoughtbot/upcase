require "rails_helper"

describe DecksController do
  describe "#index" do
    it { requires_signed_in_user_to { get :index } }
  end

  describe "#show" do
    it { requires_signed_in_user_to { get :show, id: 1 } }
  end
end
