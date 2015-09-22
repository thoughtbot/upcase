require "rails_helper"

describe FlashcardsController do
  describe "#show" do
    it { requires_signed_in_user_to { get :show, id: 1, deck_id: 2 } }
  end
end
