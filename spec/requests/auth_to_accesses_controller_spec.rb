require "rails_helper"

RSpec.describe AuthToAccessesController do
  describe "show" do
    it "redirects to auth path" do
      video = create(:video)

      get(video_auth_to_access_path(video))

      params = {origin: video_path(video)}
      expect(response).to redirect_to(
        "#{OmniAuth.config.path_prefix}/github?#{params.to_query}"
      )
    end
  end
end
