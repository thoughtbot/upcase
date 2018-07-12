require "rails_helper"

describe FlashcardsController do
  describe "#show" do
    it { requires_signed_in_user_to { view_a_flash_card } }
  end

  def view_a_flash_card
    get :show, params: { id: 1, deck_id: 2 }
  end
end
