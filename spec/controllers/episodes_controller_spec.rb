require 'spec_helper'

include StubCurrentUserHelper

describe EpisodesController do
  describe '#show when viewing a video as a subscriber' do
    it 'redirects to purchase view so they can watch video' do
      user = create(:subscriber)
      video = create(:video)
      purchase = create(:purchase, user: user, purchaseable: video.watchable)
      controller.stubs(:signed_in?).returns(true)
      stub_current_user_with(user)

      get :show, id: video

      expect(response).to(
        redirect_to([purchase, video])
      )
    end
  end
end
